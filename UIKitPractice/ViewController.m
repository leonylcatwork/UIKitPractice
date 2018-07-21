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
@property (nonatomic, strong) UITableView *tableView2;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initModels];
    [self setArray];
    
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(BookCell.class) bundle:nil]
     forCellReuseIdentifier:NSStringFromClass(BookCell.class)];


    UIView *view = UIView.new;
    view.frame = CGRectMake(0, 0, 100, 100);
    view.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.1];
    UIButton *buttonNextView = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonNextView.frame = CGRectMake(screen.size.width - 75, 25, 50, 50);
    buttonNextView.backgroundColor = [UIColor whiteColor];
    [buttonNextView addTarget:self action:@selector(clickButtonNextView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonNextView];

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
    
    /*NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@ "Categorys.plist"];
    
    self.data = [NSArray arrayWithContentsOfFile:fileName];*/
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
    if ([tableView isEqual:self.tableView]) {
        BookCell *bookCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(BookCell.class) forIndexPath:indexPath];
        Book *book = [self.data[indexPath.section] books][indexPath.row];
        [bookCell setTitle:book.title];
        return bookCell;
    } else {
        CGRect screen = [[UIScreen mainScreen] bounds];
        
        UITableViewCell *view = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, 50)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 11, screen.size.width, 22)];
        Book *book = [self.data[indexPath.section] books][indexPath.row];
        label.text = book.title;
        [view addSubview:label];
        return view;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect screen = [[UIScreen mainScreen] bounds];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, screen.size.width, 50);
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:[self.data[section] title] forState:UIControlStateNormal];
    if ([tableView isEqual:self.tableView]) [button addTarget:self action:@selector(clickHeaderInSection:) forControlEvents:UIControlEventTouchUpInside];
    else [button addTarget:self action:@selector(clickHeaderInSection2:) forControlEvents:UIControlEventTouchUpInside];
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
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)clickHeaderInSection2:(UIButton *)sender {
    int section = (int)sender.tag - 1000;
    NSString *string = [self.array objectAtIndex:section];
    if ([string  isEqual: @"0"]) {
        [self.array replaceObjectAtIndex:section withObject:@"1"];
    } else {
        [self.array replaceObjectAtIndex:section withObject:@"0"];
    }
    [self.tableView2 reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)clickButtonNextView:(id)sender {
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    [self initModels];
    [self setArray];
    
    UIView *view2 = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view2.tag = 2000;
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    
    UIView *viewlll = UIView.new;
    viewlll.frame = CGRectMake(0, statusRect.size.height, screen.size.width, 100);
    viewlll.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.1];
    [view2 addSubview:viewlll];
    
    UIButton *buttonLastView = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonLastView.frame = CGRectMake(25, 25, 50, 50);
    buttonLastView.backgroundColor = [UIColor whiteColor];
    [buttonLastView addTarget:self action:@selector(clickButtonLastView:) forControlEvents:UIControlEventTouchUpInside];
    [viewlll addSubview:buttonLastView];
    
    self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height) style:UITableViewStylePlain];
    self.tableView2.tableHeaderView = viewlll;
    self.tableView2.tableFooterView = nil;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    [view2 addSubview:self.tableView2];
}


- (void)clickButtonLastView:(id)sender {
    [[[UIApplication sharedApplication].keyWindow viewWithTag:2000] removeFromSuperview];
}

@end
