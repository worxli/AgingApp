//
//  FaceFrontierDemographicViewController.m
//  Face Frontier
//
//  Created by Kathleen Tuite on 4/14/14.
//  Copyright (c) 2014 Kathleen Tuite. All rights reserved.
//

#import "FaceFrontierDemographicViewController.h"
#import "FaceFrontierLoginSettings.h"

#import "AFNetworking.h"

@interface FaceFrontierDemographicViewController ()

@end

@implementation FaceFrontierDemographicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.age = @"";
    self.gender = @"";
    self.country = @"";
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 100; i++) {
        [array addObject: [NSString stringWithFormat:@"%ld",(long)i]];
    }
    
    self.ageArray = [[NSArray alloc] initWithArray:array];
    
    self.genderArray  = [[NSArray alloc] initWithObjects:@"female", @"male", nil];
    
    self.countryArray = [[NSArray alloc] initWithObjects:@"Country?",
                           @"United States of America",
                           @"Afghanistan",
                           @"Albania",
                           @"Algeria",
                           @"American Samoa",
                           @"Andorra",
                           @"Angola",
                           @"Anguilla",
                           @"Antarctica",
                           @"Antigua & Barbuda",
                           @"Argentina",
                           @"Armenia",
                           @"Aruba",
                           @"Australia",
                           @"Austria",
                           @"Azerbaijan",
                           @"Bahama",
                           @"Bahrain",
                           @"Bangladesh",
                           @"Barbados",
                           @"Belarus",
                           @"Belgium",
                           @"Belize",
                           @"Benin",
                           @"Bermuda",
                           @"Bhutan",
                           @"Bolivia",
                           @"Bosnia and Herzegovina",
                           @"Botswana",
                           @"Bouvet Island",
                           @"Brazil",
                           @"British Indian Ocean Territory",
                           @"British Virgin Islands",
                           @"Brunei Darussalam",
                           @"Bulgaria",
                           @"Burkina Faso",
                           @"Burundi",
                           @"Cambodia",
                           @"Cameroon",
                           @"Canada",
                           @"Cape Verde",
                           @"Cayman Islands",
                           @"Central African Republic",
                           @"Chad",
                           @"Chile",
                           @"China",
                           @"Christmas Island",
                           @"Cocos (Keeling) Islands",
                           @"Colombia",
                           @"Comoros",
                           @"Congo",
                           @"Cook Iislands",
                           @"Costa Rica",
                           @"Croatia",
                           @"Cuba",
                           @"Cyprus",
                           @"Czech Republic",
                           @"Denmark",
                           @"Djibouti",
                           @"Dominica",
                           @"Dominican Republic",
                           @"East Timor",
                           @"Ecuador",
                           @"Egypt",
                           @"El Salvador",
                           @"Equatorial Guinea",
                           @"Eritrea",
                           @"Estonia",
                           @"Ethiopia",
                           @"Falkland Islands (Malvinas)",
                           @"Faroe Islands",
                           @"Fiji",
                           @"Finland",
                           @"France",
                           @"France, Metropolitan",
                           @"French Guiana",
                           @"French Polynesia",
                           @"French Southern Territories",
                           @"Gabon",
                           @"Gambia",
                           @"Georgia",
                           @"Germany",
                           @"Ghana",
                           @"Gibraltar",
                           @"Greece",
                           @"Greenland",
                           @"Grenada",
                           @"Guadeloupe",
                           @"Guam",
                           @"Guatemala",
                           @"Guinea",
                           @"Guinea-Bissau",
                           @"Guyana",
                           @"Haiti",
                           @"Heard & McDonald Islands",
                           @"Honduras",
                           @"Hong Kong",
                           @"Hungary",
                           @"Iceland",
                           @"India",
                           @"Indonesia",
                           @"Iraq",
                           @"Ireland",
                           @"Islamic Republic of Iran",
                           @"Israel",
                           @"Italy",
                           @"Ivory Coast",
                           @"Jamaica",
                           @"Japan",
                           @"Jordan",
                           @"Kazakhstan",
                           @"Kenya",
                           @"Kiribati",
                           @"Korea, Democratic People's Republic of",
                           @"Korea, Republic of",
                           @"Kuwait",
                           @"Kyrgyzstan",
                           @"Lao People's Democratic Republic",
                           @"Latvia",
                           @"Lebanon",
                           @"Lesotho",
                           @"Liberia",
                           @"Libyan Arab Jamahiriya",
                           @"Liechtenstein",
                           @"Lithuania",
                           @"Luxembourg",
                           @"Macau",
                           @"Madagascar",
                           @"Malawi",
                           @"Malaysia",
                           @"Maldives",
                           @"Mali",
                           @"Malta",
                           @"Marshall Islands",
                           @"Martinique",
                           @"Mauritania",
                           @"Mauritius",
                           @"Mayotte",
                           @"Mexico",
                           @"Micronesia",
                           @"Moldova, Republic of",
                           @"Monaco",
                           @"Mongolia",
                           @"Monserrat",
                           @"Morocco",
                           @"Mozambique",
                           @"Myanmar",
                           @"Namibia",
                           @"Nauru",
                           @"Nepal",
                           @"Netherlands",
                           @"Netherlands Antilles",
                           @"New Caledonia",
                           @"New Zealand",
                           @"Nicaragua",
                           @"Niger",
                           @"Nigeria",
                           @"Niue",
                           @"Norfolk Island",
                           @"Northern Mariana Islands",
                           @"Norway",
                           @"Oman",
                           @"Pakistan",
                           @"Palau",
                           @"Panama",
                           @"Papua New Guinea",
                           @"Paraguay",
                           @"Peru",
                           @"Philippines",
                           @"Pitcairn",
                           @"Poland",
                           @"Portugal",
                           @"Puerto Rico",
                           @"Qatar",
                           @"Reunion",
                           @"Romania",
                           @"Russian Federation",
                           @"Rwanda",
                           @"Saint Lucia",
                           @"Samoa",
                           @"San Marino",
                           @"Sao Tome & Principe",
                           @"Saudi Arabia",
                           @"Senegal",
                           @"Seychelles",
                           @"Sierra Leone",
                           @"Singapore",
                           @"Slovakia",
                           @"Slovenia",
                           @"Solomon Islands",
                           @"Somalia",
                           @"South Africa",
                           @"South Georgia and the South Sandwich Islands",
                           @"Spain",
                           @"Sri Lanka",
                           @"St. Helena",
                           @"St. Kitts and Nevis",
                           @"St. Pierre & Miquelon",
                           @"St. Vincent & the Grenadines",
                           @"Sudan",
                           @"Suriname",
                           @"Svalbard & Jan Mayen Islands",
                           @"Swaziland",
                           @"Sweden",
                           @"Switzerland",
                           @"Syrian Arab Republic",
                           @"Taiwan",
                           @"Tajikistan",
                           @"Tanzania, United Republic of",
                           @"Thailand",
                           @"Togo",
                           @"Tokelau",
                           @"Tonga",
                           @"Trinidad & Tobago",
                           @"Tunisia",
                           @"Turkey",
                           @"Turkmenistan",
                           @"Turks & Caicos Islands",
                           @"Tuvalu",
                           @"Uganda",
                           @"Ukraine",
                           @"United Arab Emirates",
                           @"United Kingdom (Great Britain)",
                           @"United States Minor Outlying Islands",
                           @"United States Virgin Islands",
                           @"Uruguay",
                           @"Uzbekistan",
                           @"Vanuatu",
                           @"Vatican City State (Holy See)",
                           @"Venezuela",
                           @"Viet Nam",
                           @"Wallis & Futuna Islands",
                           @"Western Sahara",
                           @"Yemen",
                           @"Yugoslavia",
                           @"Zaire",
                           @"Zambia",
                           @"Zimbabwe", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.agePicker){
        return self.ageArray.count;
    }
    else if (pickerView == self.genderPicker){
        return self.genderArray.count;
    }
    else if (pickerView == self.countryPicker){
        return self.countryArray.count;
    }
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (pickerView == self.agePicker){
        return [self.ageArray objectAtIndex:row];
    }
    else if (pickerView == self.genderPicker){
        return [self.genderArray objectAtIndex:row];
    }
    else if (pickerView == self.countryPicker){
        return [self.countryArray objectAtIndex:row];
    }
    
    return @"???";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    if (pickerView == self.agePicker){
        self.age = [self.ageArray objectAtIndex:row];
    }
    else if (pickerView == self.genderPicker){
        self.gender = [self.genderArray objectAtIndex:row];
    }
    else if (pickerView == self.countryPicker){
        self.country = [self.countryArray objectAtIndex:row];
    }
}

- (IBAction)amendAccount:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"defaults value for key %@",[defaults valueForKey:@"user_id"]);NSLog(@"%@, %@, %@", self.age, self.gender, self.country);
    
    int user_id = (int)[defaults integerForKey:@"user_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"user_id": [NSNumber numberWithInt:user_id], @"age": self.age, @"gender": self.gender, @"country": self.country};
    [manager POST:[NSString stringWithFormat:@"%@/iphone/amend_account/", serverUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // TOOD: some segue
        [self performSegueWithIdentifier:@"account_made" sender:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self alertStatus:@"Couldn't reach login server" :@"Account Creation Failed!" :0];
    }];

}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

@end
