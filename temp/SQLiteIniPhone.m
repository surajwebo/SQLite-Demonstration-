//
//
//  Created by Bhuvan Khanna on 28/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SQLiteIniPhone.h"

@interface SQLiteIniPhone ()

@end

@implementation SQLiteIniPhone
@synthesize imgViewBG;
@synthesize lblTitle;
@synthesize txtFieldTitle;
@synthesize txtFieldAge;
@synthesize dBName;
@synthesize dBTable;
@synthesize arraydBTableColumns;
@synthesize viewInfoPage;
@synthesize customView;
@synthesize tapgestureOnInfoView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dBName = @"myDB.sqlite";
        dBTable = @"Table1";
        arraydBTableColumns = [[NSArray alloc] initWithObjects:@"Name", @"Age", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
}
- (void)viewDidUnload
{
    [self setImgViewBG:nil];
    [self setLblTitle:nil];
    [self setTxtFieldTitle:nil];
    [self setTxtFieldAge:nil];
    [self setViewInfoPage:nil];
    [self setCustomView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [imgViewBG release];
    [lblTitle release];
    [txtFieldTitle release];
    [txtFieldAge release];
    [arraydBTableColumns release];
    [viewInfoPage release];
    [customView release];
    [tapgestureOnInfoView release];
    [super dealloc];
}

- (IBAction)addToDB:(id)sender {
    BOOL bIsDBExists = [self checkDBExists: dBName];
    if ([txtFieldTitle.text length] != 0 && [txtFieldAge.text length] !=0) {
        if (!bIsDBExists) {
            [self createDB :dBName :dBTable :arraydBTableColumns];
        } else {
            [self insertRecordToDBTable :dBName :dBTable :arraydBTableColumns];
        }
    } else {
        UIAlertView *alrtMsg = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please insert values in fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrtMsg show];
        [alrtMsg release];
    }
    [self clearUIControls];
}

- (IBAction)updateRecordInDB:(id)sender {
    BOOL bIsDBExists = [self checkDBExists: dBName];
    if ([txtFieldTitle.text length] != 0 && [txtFieldAge.text length] !=0) {
        if (!bIsDBExists) {
            [self createDB :dBName :dBTable :arraydBTableColumns];
        } else {
            [self updateRecordFromDBTable:dBName :dBTable :arraydBTableColumns];
        }
    } else {
        UIAlertView *alrtMsg = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please insert values in fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrtMsg show];
        [alrtMsg release];
    }
    [self clearUIControls];
}

- (IBAction)deleteRecordFromDB:(id)sender {
    BOOL bIsDBExists = [self checkDBExists: dBName];
    if ([txtFieldTitle.text length] != 0 && [txtFieldAge.text length] !=0) {
        if (!bIsDBExists) {
            [self createDB :dBName :dBTable :arraydBTableColumns];
        } else {
            [self deleteRecordFromDBTable:dBName :dBTable :arraydBTableColumns];
        }
    } else {
        UIAlertView *alrtMsg = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please insert values in fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrtMsg show];
        [alrtMsg release];
    }
    [self clearUIControls];
}

- (IBAction)navigateToInfoScreen:(id)sender {
    //UIButton *senderButton = (UIButton*)sender;
    customView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, 248, 185)];
    customView.alpha = 0.0;
    customView.layer.cornerRadius = 5;
    customView.layer.borderWidth = 1.5f;
    customView.layer.masksToBounds = YES;
    
    [customView addSubview:viewInfoPage];
    [self.view addSubview:customView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [customView setAlpha:1.0];
    [UIView commitAnimations];
    [UIView setAnimationDuration:0.0];
    
    tapgestureOnInfoView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeInfoViewFromScreen)];
    [customView addGestureRecognizer:tapgestureOnInfoView];
    [self.view addGestureRecognizer:tapgestureOnInfoView];
    customView.userInteractionEnabled = YES;
}

-(void)removeInfoViewFromScreen {
    [customView removeFromSuperview];
    [self.view removeGestureRecognizer:tapgestureOnInfoView];
}

-(NSString *) documentDirectory
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    return documentsDirectory;
}

-(BOOL)checkDBExists:(NSString *)databaseName {
    NSString *databasePath = [[self documentDirectory] stringByAppendingPathComponent:databaseName]; 
    NSLog(@"DATABASE PATH = %@",databasePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:databasePath];
    return success;
}

-(void)createDB: (NSString *)databaseName: (NSString *)databaseTable: (NSArray *)databaseColumns {
    NSString *databasePath = [[self documentDirectory] stringByAppendingPathComponent:databaseName]; 
    char *error;    
    const char *dbPath=[databasePath UTF8String]; 
    if(sqlite3_open(dbPath, &database)==SQLITE_OK) 
    { 
        NSString *createSQL = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT, %@ INTEGER)",databaseTable,[databaseColumns objectAtIndex:0], [databaseColumns objectAtIndex:1]]; 
        const char *createSQL_stmt = [createSQL UTF8String];
        if (sqlite3_exec(database, createSQL_stmt, NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"Database created and table added.");
        }
        else
        {
            NSLog(@"Error %i", sqlite3_errcode(database));
            NSLog(@"Error %s", sqlite3_errmsg(database));
        }
    }
    else
    {
        NSLog(@"Error %i", sqlite3_errcode(database));
        NSLog(@"Error %s", sqlite3_errmsg(database));
    }
}

-(void)insertRecordToDBTable: (NSString *)databaseName: (NSString *)databaseTable: (NSArray *)databaseColumns
{
    NSString *databasePath = [[self documentDirectory] stringByAppendingPathComponent:databaseName];
    char *error;    
    const char *dbPath=[databasePath UTF8String]; 
    if(sqlite3_open(dbPath, &database)==SQLITE_OK) 
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@) VALUES (\"%@\", \"%@\")", databaseTable,[databaseColumns objectAtIndex:0],[databaseColumns objectAtIndex:1], txtFieldTitle.text, txtFieldAge.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        if(sqlite3_exec(database, insert_stmt, NULL, NULL, &error)==SQLITE_OK)
        {
            NSLog(@"Data inserted into Database: %@ Table: %@",databaseName, databaseTable);
            UIAlertView *alrtMsg = [[UIAlertView alloc] initWithTitle:@"SQLite" message:@"Record inserted to Database" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrtMsg show];
            [alrtMsg release];
        }
        else
        {
            NSLog(@"Error %i", sqlite3_errcode(database));
            NSLog(@"Error %s", sqlite3_errmsg(database));
        }
    }
    sqlite3_close(database);
}

-(void)updateRecordFromDBTable: (NSString *)databaseName: (NSString *)databaseTable: (NSArray *)databaseColumns {
    NSString *databasePath = [[self documentDirectory] stringByAppendingPathComponent:databaseName];
    const char *dbPath=[databasePath UTF8String];
    NSString *sql_str=[NSString stringWithFormat:@"UPDATE %@ SET %@=%@ WHERE %@='%@'", databaseTable,[databaseColumns objectAtIndex:1],txtFieldAge.text,[databaseColumns objectAtIndex:0],txtFieldTitle.text];
    const char *sql = [sql_str UTF8String];
    char *error; 
    if(sqlite3_open(dbPath, &database) == SQLITE_OK)
    {
        sqlite3_stmt *updateStmt;
        if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) == SQLITE_OK)
        {            
            if(sqlite3_exec(database, sql, NULL, NULL, &error)==SQLITE_OK) {
                NSLog(@"Data updated");
                UIAlertView *alrtMsg = [[UIAlertView alloc] initWithTitle:@"SQLite" message:@"Record updated in Database" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alrtMsg show];
                [alrtMsg release];
            } else {
                NSLog(@"Error %i", sqlite3_errcode(database));
                NSLog(@"Error %s", sqlite3_errmsg(database));
            }
        }
        sqlite3_finalize(updateStmt);
    }
    sqlite3_close(database);
}


-(void)deleteRecordFromDBTable: (NSString *)databaseName: (NSString *)databaseTable: (NSArray *)databaseColumns
{
    NSString *databasePath = [[self documentDirectory] stringByAppendingPathComponent:databaseName];
    const char *dbPath=[databasePath UTF8String];
    NSString *sql_str=[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@' AND %@='%@'", databaseTable,[databaseColumns objectAtIndex:0],txtFieldTitle.text,[databaseColumns objectAtIndex:1],txtFieldAge.text];
    const char *sql = [sql_str UTF8String];
    if(sqlite3_open(dbPath, &database) == SQLITE_OK)
    {
        sqlite3_stmt *deleteStmt;
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(deleteStmt) != SQLITE_DONE )
            {
                NSLog( @"Error: %s", sqlite3_errmsg(database) );
            }
            else
            {
                NSLog(@"Record Deleted");
                UIAlertView *alrtMsg = [[UIAlertView alloc] initWithTitle:@"SQLite" message:@"Record deleted from Database" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alrtMsg show];
                [alrtMsg release];
            }
        }
        sqlite3_finalize(deleteStmt);
    }
    sqlite3_close(database);
}

- (IBAction)fetchRecordsFromDB:(id)sender {
    [self selectRecordFromDBTable:dBName :dBTable];
}

-(void)selectRecordFromDBTable: (NSString *)databaseName: (NSString *)databaseTable {
    NSString *databasePath = [[self documentDirectory] stringByAppendingPathComponent:databaseName];
    const char *dbPath=[databasePath UTF8String];
    NSString *sql_str=[NSString stringWithFormat:@"SELECT * FROM %@;", databaseTable];
    const char *sql = [sql_str UTF8String];
    if(sqlite3_open(dbPath, &database) == SQLITE_OK)
    {
        sqlite3_stmt *selectStmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectStmt, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(selectStmt) == SQLITE_ROW)
           {
                NSLog(@"Record Fetched");
                NSString *strRecordsName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(selectStmt, 1)];
                NSString *strRecordsAge  = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(selectStmt, 2)];
                
                NSString *strRecord = [[[@"Name: " stringByAppendingString:strRecordsName] stringByAppendingString:@"Age: "] stringByAppendingString:strRecordsAge];
                UIAlertView *alrtMsg = [[UIAlertView alloc] initWithTitle:@"SQLite" message:strRecord delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //[alrtMsg show];
                [alrtMsg release];
               
               NSLog(@"Name:- %@ Age:- %@",strRecordsName, strRecordsAge);
            }
        }
        sqlite3_finalize(selectStmt);
    }
    sqlite3_close(database);
}

-(void)clearUIControls {
    txtFieldTitle.text = @"";
    txtFieldAge.text   = @"";
}


@end
