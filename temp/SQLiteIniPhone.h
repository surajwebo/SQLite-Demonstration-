//
//
//  Created by Bhuvan Khanna on 28/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>

@interface SQLiteIniPhone : UIViewController <UIImagePickerControllerDelegate, UIPopoverControllerDelegate> {
    sqlite3 *database;
    NSString *dBName;
    NSString *dBTable;
    NSArray *arraydBTableColumns;
    UIView *customView;
    UITapGestureRecognizer *tapgestureOnInfoView;
}
@property (retain, nonatomic) IBOutlet UIImageView *imgViewBG;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UITextField *txtFieldTitle;
@property (retain, nonatomic) IBOutlet UITextField *txtFieldAge;
@property (retain) NSString *dBName;
@property (retain) NSString *dBTable;
@property (retain, nonatomic) NSArray *arraydBTableColumns;
@property (retain, nonatomic) IBOutlet UIView *viewInfoPage;
@property (retain, nonatomic) UIView *customView;
@property (retain, nonatomic) UITapGestureRecognizer *tapgestureOnInfoView;

- (IBAction)addToDB:(id)sender;
- (IBAction)updateRecordInDB:(id)sender;
- (IBAction)deleteRecordFromDB:(id)sender;
- (IBAction)navigateToInfoScreen:(id)sender;
- (IBAction)fetchRecordsFromDB:(id)sender;

-(NSString *) documentDirectory;
-(BOOL)checkDBExists:(NSString *)databaseName;
-(void)createDB: (NSString *)databaseName: (NSString *)databaseTable: (NSArray *)databaseColumns;
-(void)insertRecordToDBTable: (NSString *)databaseName: (NSString *)databaseTable: (NSArray *)databaseColumns;
-(void)updateRecordFromDBTable: (NSString *)databaseName: (NSString *)databaseTable: (NSArray *)databaseColumns;
-(void)deleteRecordFromDBTable: (NSString *)databaseName: (NSString *)databaseTable: (NSArray *)databaseColumns;
-(void)clearUIControls;
-(void)selectRecordFromDBTable: (NSString *)databaseName: (NSString *)databaseTable;

@end
