//
//  ViewController.m
//  UIKitPractice
//
//  Created by leon on 20/07/2018.
//  Copyright © 2018 Maimemo Inc. All rights reserved.
//

#import "ViewController.h"
#import "Category.h"
#import "BookCell.h"
#import "MyButton.h"
#import "ViewController2.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray <Category *> *data;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) ViewController2 *viewController2;
- (IBAction)nextView:(UIBarButtonItem *)sender;

- (NSString *)replaceUnicode:(NSString *)unicodeStr;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initModels];
    [self setArray];
    
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(BookCell.class) bundle:nil]
     forCellReuseIdentifier:NSStringFromClass(BookCell.class)];


    UIView *view = UIView.new;
    view.frame = CGRectMake(0, 0, 100, 100);
    view.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.1];
    
    _tableView.tableHeaderView = view;
    _tableView.tableFooterView = UIView.new;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}


- (void)setArray {
    self.array = [[NSMutableArray alloc] init];
    int i;
    for (i = 0; i < self.data.count; i++){
        [self.array addObject:@"0"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initModels {
    Category *category = Category.new;
    category.title = @"小学英语";
    Book *book1 = Book.new;
    book1.title = @"小学英语1年级";
    book1.author = @"未知1";

    Book *book2 = Book.new;
    book2.title = @"小学英语2年级";
    book2.author = @"未知2";

    category.books = [NSArray arrayWithObjects:book1, book2, nil];
    
    Category *category2 = Category.new;
    category2.title = @"初中英语";
    Book *book3 = Book.new;
    book3.title = @"初中英语1年级";
    book3.author = @"未知1";
    
    Book *book4 = Book.new;
    book4.title = @"初中英语2年级";
    book4.author = @"未知2";
    
    Book *book5 = Book.new;
    book5.title = @"初中英语3年级";
    book5.author = @"未知2";
    
    category2.books = [NSArray arrayWithObjects:book3, book4, book5, nil];

    self.data = @[category, category2];
    /*NSString *path = [[NSBundle mainBundle] pathForResource:@"JSONString" ofType:@"txt"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@", jsonString);
    
    NSData *JSONData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *responseJSON = nil;
    if (JSONData) {
        responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    }
    
    NSLog(@"%@", responseJSON);*/
    
}

- (IBAction)nextView:(UIBarButtonItem *)sender {
    if (!_viewController2) {
        _viewController2 = [[ViewController2 alloc] init];
    }
    
    [self.navigationController pushViewController:_viewController2 animated:YES];
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData
                                                                    options:NSPropertyListImmutable
                                                                     format:NULL
                                                                      error:NULL];
    
    //NSLog(@"Output = %@", returnStr);
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

#pragma mark - table view data source / delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *string;
    string = [self.array objectAtIndex:section];
    if ([string  isEqual: @"0"]) return 0;
    else return [[self.data[section] books] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookCell *bookCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(BookCell.class) forIndexPath:indexPath];
    Book *book = [self.data[indexPath.section] books][indexPath.row];
    [bookCell setTitle:book.title];
    return bookCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect screen = [[UIScreen mainScreen] bounds];
    MyButton *button = [MyButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, screen.size.width, 50);
    button.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [button setTitle:[self.data[section] title] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickHeaderInSection:) forControlEvents:UIControlEventTouchUpInside];
    button.section = (int)section;
    return button;
}


- (void)clickHeaderInSection:(MyButton *)sender {
    int section = sender.section;
    NSString *string = [self.array objectAtIndex:section];
    if ([string  isEqual: @"0"]) {
        [self.array replaceObjectAtIndex:section withObject:@"1"];
    } else {
        [self.array replaceObjectAtIndex:section withObject:@"0"];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

@end
