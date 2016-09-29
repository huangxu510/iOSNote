//
//  ViewController.m
//  IAPTest
//
//  Created by huangxu on 16/4/26.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>

@interface ViewController ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    buyButton.frame = CGRectMake(100, 100, 200, 50);
    [buyButton setTitle:@"购买" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)buy
{
    if ([SKPaymentQueue canMakePayments]) {
        [self getProductInfo];
    } else {
        NSLog(@"失败，用户禁止应用内付费购买！");
    }
}

- (void)getProductInfo
{
    NSSet *set = [NSSet setWithArray:@[@"ProductId"]];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *myProducts = response.products;
    if (myProducts.count == 0) {
        NSLog(@"无法获取产品信息, 购买失败");
        return;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:myProducts[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSString *productIdentifier = transaction.payment.productIdentifier;
    //NSString *receipt = transaction.transactionReceipt;
    NSURL *receipt = [[NSBundle mainBundle] appStoreReceiptURL];
    
    if ([productIdentifier length] > 0) {
        //向自己的服务器验证购买凭证
    }
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败! error:%@", transaction.error.localizedDescription);
    } else {
        NSLog(@"用户取消交易");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    // 对于已购商品，处理恢复购买的逻辑
    
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
