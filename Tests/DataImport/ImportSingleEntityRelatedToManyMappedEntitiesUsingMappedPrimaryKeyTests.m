//
//  Import SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyTests.m
//  Magical Record
//
//  Created by Saul Mora on 8/16/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey.h"
#import "MagicalDataImportTestCase.h"

@interface ImportSingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyTests : MagicalDataImportTestCase

@end

@implementation ImportSingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyTests

- (Class)testEntityClass
{
    return [SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey class];
}

- (void)testImportData
{
    SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey *entity = [[self testEntityClass] MR_importFromObject:self.testEntityData inContext:[NSManagedObjectContext MR_defaultContext]];
    
    XCTAssertNotNil(entity, @"Entity should not be nil");

    XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for managed object context"];

    [entity.managedObjectContext performBlock:^{
        NSUInteger mappedEntitiesCount = entity.mappedEntities.count;
        XCTAssertEqual(mappedEntitiesCount, (NSUInteger)4, @"Expected 4 mapped entities, received %zd", mappedEntitiesCount);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError * _Nullable error) {
        MRLogError(@"Managed Object Context performBlock: timed out due to error: %@", [error localizedDescription]);
    }];
}

- (void)testImportNilData
{
    SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey *entity = [[self testEntityClass] MR_importFromObject:self.testEntityData inContext:[NSManagedObjectContext MR_defaultContext]];
    
    XCTAssertNotNil(entity, @"Entity should not be nil");
    
    [entity.managedObjectContext performBlockAndWait:^{
        // testing that importing nothing will not change the relationship
        [entity MR_importValuesForKeysWithObject:@{}];
        NSUInteger mappedEntitiesCount = entity.mappedEntities.count;
        XCTAssertEqual(mappedEntitiesCount, (NSUInteger)4, @"Expected 4 mapped entities, received %zd", mappedEntitiesCount);
        
        // testing that importing `null` will nullify the relationship
        [entity MR_importValuesForKeysWithObject:@{@"mappedEntities":[NSNull null]}];
        mappedEntitiesCount = entity.mappedEntities.count;
        XCTAssertEqual(mappedEntitiesCount, (NSUInteger)0, @"Expected 0 mapped entities, received %zd", mappedEntitiesCount);
    }];
}

@end
