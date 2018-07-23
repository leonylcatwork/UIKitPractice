//
//  ViewController2.m
//  UIKitPractice
//
//  Created by Yuan Ana on 2018/7/23.
//  Copyright © 2018 Maimemo Inc. All rights reserved.
//

#import "ViewController2.h"
#import "Category.h"
#import "MyButton.h"


@interface ViewController2 () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray <Category *> *data2;
@property (nonatomic, weak) UITableView *tableView2;
@property (nonatomic, strong) NSMutableArray *array2;

- (NSString *)replaceUnicode:(NSString *)unicodeStr;

@end


@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initModels];
    [self setArray];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView2 = tableView;
    [self.view addSubview:_tableView2];
    
    UIView *view = UIView.new;
    view.frame = CGRectMake(0, 0, 100, 100);
    view.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.1];
    UIButton *buttonNextView = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonNextView.frame = CGRectMake(25, 25, 50, 50);
    buttonNextView.backgroundColor = [UIColor whiteColor];
    [buttonNextView addTarget:self action:@selector(clickButtonLastView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonNextView];
    
    _tableView2.tableHeaderView = view;
    _tableView2.tableFooterView = UIView.new;
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    [_tableView2 addSubview:view];
}


- (void)setArray {
    self.array2 = [[NSMutableArray alloc] init];
    int i;
    for (i = 0; i < self.data2.count; i++){
        [self.array2 addObject:@"0"];
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
    
    self.data2 = @[category, category2];
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
    return self.data2.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *string;
    string = [self.array2 objectAtIndex:section];
    if ([string  isEqual: @"0"]) return 0;
    else return [[self.data2[section] books] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screen = [[UIScreen mainScreen] bounds];
        
    UITableViewCell *view = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 11, screen.size.width, 22)];
    Book *book = [self.data2[indexPath.section] books][indexPath.row];
    label.text = book.title;
    [view addSubview:label];
    return view;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect screen = [[UIScreen mainScreen] bounds];
    MyButton *button = [MyButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, screen.size.width, 50);
    button.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [button setTitle:[self.data2[section] title] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickHeaderInSection:) forControlEvents:UIControlEventTouchUpInside];
    button.section = (int)section;
    return button;
}


- (void)clickHeaderInSection:(MyButton *)sender {
    int section = sender.section;
    NSString *string = [self.array2 objectAtIndex:section];
    if ([string  isEqual: @"0"]) {
        [self.array2 replaceObjectAtIndex:section withObject:@"1"];
    } else {
        [self.array2 replaceObjectAtIndex:section withObject:@"0"];
    }
    [self.tableView2 reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)clickButtonLastView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
