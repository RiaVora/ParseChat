//
//  ViewController.m
//  ParseChat
//
//  Created by Ria Vora on 7/6/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)pressedSignUp:(id)sender {
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameTextField.text;
    newUser.password = self.passwordTextField.text;
    
    if ([newUser.username isEqual:@""]) {
        [self displayAlertEmpty:@"Username"];
    }
    
    if ([newUser.password isEqual:@""]) {
        [self displayAlertEmpty:@"Password"];
    }
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"New user of name %@ signup succeeded", newUser.username);
            self.usernameTextField.text = @"";
            self.passwordTextField.text = @"";
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
            [self displayAlert:@"Error with Signing Up" :error.localizedDescription];
        }
    }];
    

}
- (IBAction)pressedLogin:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if ([username isEqual:@""]) {
        [self displayAlertEmpty:@"Username"];
    }
    
    if ([password isEqual:@""]) {
        [self displayAlertEmpty:@"Password"];
    }
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self displayAlert:@"Error with Logging in" :error.localizedDescription];
        } else {
            NSLog(@"User %@ logged in successfully", username);
            self.usernameTextField.text = @"";
            self.passwordTextField.text = @"";
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];

        }
    }];
    
    
}

- (void)displayAlertEmpty:(NSString *)field {
    [self displayAlert: @"Cannot be Empty": [NSString stringWithFormat: @"%@ cannot be empty", field]] ;
}

- (void)displayAlert:(NSString *)title :(NSString *)message {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
      style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * _Nonnull action) {
            // handle response here.
    }];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
}

@end
