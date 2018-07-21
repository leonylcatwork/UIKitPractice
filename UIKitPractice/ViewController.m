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


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray <Category *> *data;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;

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

    self.data = @[category];
}


#pragma mark - table view data source / delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *string = [self.array objectAtIndex:section];
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, screen.size.width, 50);
    [button setTitle:[self.data[section] title] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickHeaderInSection:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = section + 1000;
    return button;
}


- (void)clickHeaderInSection:(UIButton *)sender {
    int section = (int)sender.tag - 1000;
    NSString *string = [self.array objectAtIndex:section];
    if ([string  isEqual: @"0"]) {
        [self.array replaceObjectAtIndex:section withObject:@"1"];
    } else {
        [self.array replaceObjectAtIndex:section withObject:@"0"];
    }
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:temp] withRowAnimation:(UITableViewRowAnimationFade)];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}



@end
