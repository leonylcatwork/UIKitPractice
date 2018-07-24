//
//  ViewController2.m
//  UIKitPractice
//
//  Created by Yuan Ana on 2018/7/23.
//  Copyright © 2018 Maimemo Inc. All rights reserved.
//

#import "ViewController2.h"
#import "Category.h"


@interface ViewController2 () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray <Category *> *data2;
@property (nonatomic, weak) UITableView *tableView2;

@end


@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initModels];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView2 = tableView;
    [self.view addSubview:_tableView2];
    
    UIView *view = UIView.new;
    view.frame = CGRectMake(0, 0, 100, 100);
    view.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.1];
    
    _tableView2.tableHeaderView = view;
    _tableView2.tableFooterView = UIView.new;
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    [_tableView2 addSubview:view];
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
    self.data2 = data;
    
}

#pragma mark - table view data source / delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data2.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.data2[section].button) {
        return 0;
    } else if (!self.data2[section].button.isOpen) {
        return 0;
    } else {
        return [[self.data2[section] books] count];
    }
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
    if (!self.data2[section].button){
        MyButton *button = [MyButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
        button.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        [button setTitle:[self.data2[section] title] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickHeaderInSection:) forControlEvents:UIControlEventTouchUpInside];
        button.section = (int)section;
        button.isOpen = NO;
        self.data2[section].button = button;
        return button;
    } else {
        return self.data2[section].button;
    }
}


- (void)clickHeaderInSection:(MyButton *)sender {
    int section = sender.section;
    if (!sender.isOpen) {
        self.data2[section].button.isOpen = YES;
    } else {
        self.data2[section].button.isOpen = NO;
    }
    [self.tableView2 reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

@end
