//
//  RDBluetoothViewController.m
//  BluetoothDemo
//
//  Created by airende on 2017/6/5.
//  Copyright © 2017年 airende. All rights reserved.
//

#import "RDBluetoothViewController.h"

@interface RDBluetoothViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *bluetoothButton;


@end

@implementation RDBluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupView];
    
    
    
}

- (void)setupData{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.separatorInset = UIEdgeInsetsZero;
    
}
- (void)setupView{

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
