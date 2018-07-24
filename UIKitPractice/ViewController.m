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
#import "ViewController2.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray <Category *> *data;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ViewController2 *viewController2;

- (IBAction)nextView:(UIBarButtonItem *)sender;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initModels];

    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initModels {
    int i, j;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JSONString" ofType:@"txt"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@", jsonString);
    
    NSData *JSONData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = nil;
    if (JSONData) {
        responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:nil];
    }
    NSArray *arrayCategory = [responseJSON objectForKey:@"category"];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (i = 0; i < arrayCategory.count; i++) {
        Category *category = [[Category alloc] init];
        NSDictionary *dictionaryCategory = arrayCategory[i];
        category.title = [dictionaryCategory objectForKey:@"title"];
        NSArray *arrayBooks = [dictionaryCategory objectForKey:@"books"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (j = 0; j < arrayBooks.count; j++) {
            NSDictionary *dictionaryBooks = arrayBooks[j];
            Book *book = [[Book alloc] init];
            book.title = [dictionaryBooks objectForKey:@"title"];
            book.author = [dictionaryBooks objectForKey:@"author"];
            [array addObject:book];
        }
        category.books = array;
        [data addObject:category];
    }
    self.data = data;
}

- (IBAction)nextView:(UIBarButtonItem *)sender {
    if (!_viewController2) {
        _viewController2 = [[ViewController2 alloc] init];
    }
    
    [self.navigationController pushViewController:_viewController2 animated:YES];
}

#pragma mark - table view data source / delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.data[section].button) {
        return 0;
    } else if (!self.data[section].button.isOpen) {
        return 0;
    } else {
        return [[self.data[section] books] count];
    }
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
    if (!self.data[section].button){
        MyButton *button = [MyButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
        button.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        [button setTitle:[self.data[section] title] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickHeaderInSection:) forControlEvents:UIControlEventTouchUpInside];
        button.section = (int)section;
        button.isOpen = NO;
        self.data[section].button = button;
        return button;
    } else {
        return self.data[section].button;
    }
}


- (void)clickHeaderInSection:(MyButton *)sender {
    int section = sender.section;
    if (!sender.isOpen) {
        self.data[section].button.isOpen = YES;
    } else {
        self.data[section].button.isOpen = NO;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

@end
