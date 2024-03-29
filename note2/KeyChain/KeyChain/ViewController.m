//
//  ViewController.m
//  KeyChain
//
//  Created by ning on 16/1/13.
//  Copyright © 2016年 宁培超. All rights reserved.
//

#import "ViewController.h"
#import "KeychainItemWrapper.h"

@interface ViewController ()

@property (nonatomic,strong) KeychainItemWrapper *keychain;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     IOS系统中，获取设备唯一标识的方法有很多：
     
     一.UDID(Unique Device Identifier)
     
     UDID的全称是Unique Device Identifier，顾名思义，它就是苹果IOS设备的唯一识别码，它由40个字符的字母和数字组成。
     
     二.UUID(Universally Unique Identifier)
     
     UUID是Universally Unique Identifier的缩写,中文意思是通用唯一识别码.
     
     三.MAC Address
     
     四.OPEN UDID
     
     五.广告标示符（IDFA-identifierForIdentifier）
     
     六.Vindor标示符 (IDFV-identifierForVendor)
     
     Vendor是CFBundleIdentifier（反转DNS格式）的前两部分。来自同一个运营商的应用运行在同一个设备上，此属性的值是相同的；不同的运营商应用运行在同一个设备上值不同。
     
     经测试，只要设备上有一个tencent的app，重新安装后的identifierForVendor值不变，如果tencent的app全部删除，重新安装后的identifierForVendor值改变。
     
     
     
     但是很不幸，上面所有这些表示设备唯一号的标识，在IOS7中要么被禁止使用，要么重新安装程序后两次获取的标识符不一样。
     
     由于IOS系统存储的数据都是在sandBox里面，一旦删除App，sandBox也不复存在。好在有一个例外，那就是keychain（钥匙串）。
     
     通常情况下，IOS系统用NSUserDefaults存储数据信息，但是对于一些私密信息，比如密码、证书等等，就需要使用更为安全的keychain了。
     
     keychain里保存的信息不会因App被删除而丢失。所以，可以利用这个keychain这个特点来保存设备唯一标识。
     
     那么，如何在应用里使用使用keyChain呢，我们需要导入Security.framework ，keychain的操作接口声明在头文件SecItem.h里。
     
     直接使用SecItem.h里方法操作keychain，需要写的代码较为复杂，我们可以使用已经封装好了的工具类KeychainItemWrapper来对keychain进行操作。
     
     KeychainItemWrapper是apple官方例子“GenericKeychain”里一个访问keychain常用操作的封装类，在官网上下载了GenericKeychain项目后，
     
     只需要把“KeychainItemWrapper.h”和“KeychainItemWrapper.m”拷贝到我们项目，并导入Security.framework 。KeychainItemWrapper的用法：
     */
    
    /** 初始化一个保存用户帐号的KeychainItemWrapper */
    KeychainItemWrapper *keychain=[[KeychainItemWrapper alloc] initWithIdentifier:@"NPC_Use_Keychain" accessGroup:nil];
    self.keychain = keychain;
    
    //保存数据
    [keychain setObject:@"794850991@qq.com" forKey:(id)kSecAttrAccount];
    [keychain setObject:@"keyChain" forKey:(id)kSecValueData];
    
    //从keychain里取出帐号密码
    NSString *password = [keychain objectForKey:(id)kSecValueData];
    
    
    //清空设置
    [keychain resetKeychainItem];
    
    /*
    其中方法“- (void)setObject:(id)inObject forKey:(id)key;”里参数“forKey”的值应该是Security.framework 里头文件“SecItem.h”里定义好的key，用其他字符串做key程序会出错！
     */
    NSLog(@"password==%@",password);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
