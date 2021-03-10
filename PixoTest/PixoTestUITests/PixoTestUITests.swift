//
//  PixoTestUITests.swift
//  PixoTestUITests
//
//  Created by Dannian Park on 2021/03/08.
//

import XCTest

class PixoTestUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false // 실패한 경우 계속 진행할지 여부 판단. false면 멈춤.

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    //MARK: - tear down test area
    //https://stackoverflow.com/a/54214537/13049349
    //teardown test area
    override class func setUp() {
        super.setUp()
        NSLog("[TEST]test setup 1")
    }
    
    override func setUp() {
        super.setUp()
        NSLog("[TEST]test setup 2")
        
    }
    
    override func tearDown() {
        super.tearDown()
        NSLog("[TEST]test tearDown 1")
    }
    
    override class func tearDown() {
        super.tearDown()
        NSLog("[TEST]test tearDown 2")
        XCUIApplication().terminate()
    }
    
    func testMethod1() {
        NSLog("[TEST]testMethod 1")
        addTeardownBlock {
            NSLog("[TEST]testMethod 1 is ended")
        }
        /*
         [TEST]test setup 1
         [TEST]test setup 2
         [TEST]testMethod 1
         [TEST]testMethod 1 is ended
         [TEST]test tearDown 1
         [TEST]test tearDown 2
         */
    }
    
    func testMethod2() {
        NSLog("[TEST]testMethod 2 is start")
        addTeardownBlock {
            NSLog("[TEST]testMethod 2 is ended 1")
        }
        
        addTeardownBlock {
            NSLog("[TEST]testMethod 2 is ended 2")
        }
        /*
         [TEST]test setup 1
         [TEST]test setup 2
         [TEST]testMethod 2 is start
         [TEST]testMethod 2 is ended 2
         [TEST]testMethod 2 is ended 1
         [TEST]test tearDown 1
         [TEST]test tearDown 2
         */
    }
    
    func testAllCaseStart(){
        addTeardownBlock {
            XCUIApplication().launch()
            self.photoSaveTest(false)
        }
        /*
        addTeardownBlock {
            XCUIApplication().launch()
            self.testAppMoveControllers(false)
        }
        
        addTeardownBlock {
            XCUIApplication().launch()
            self.testAlbumsElementTouch(false)
        }
        
        addTeardownBlock {
            XCUIApplication().launch()
            self.testPhotosElementTouch(false)
        }
        
        addTeardownBlock {
            XCUIApplication().launch()
            self.testNavibarTouch(false)
        }
        */
    }
    
    //MARK: - Each UITest Area
    //기존에 있던 방식대로 한개씩 해보고 싶다면 각 function에 throws추가.
    /**
     title button touch test
     */
    func testNavibarTouch(_ isNeedLaunch: Bool = true) {
        let app = XCUIApplication()
        if isNeedLaunch {
            app.launch()
        }
        
        let titleBtn = app.buttons["RootView.NaviTitleBtn"]
        titleBtn.tap()
        titleBtn.tap()
    }
    
    /**
     collectionview의 첫 번째 cell에 대해서 touch action check
     */
    func testPhotosElementTouch(_ isNeedLaunch: Bool = true)  {
        //firstcell select test
        let app = XCUIApplication()
        if isNeedLaunch {
            app.launch()
        }
        
        let firstChild = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        if firstChild.exists {
            firstChild.tap()
        }else{
            NSLog("WRONG FUNCTION : \(firstChild)")
        }
        //show Each Photo Display View Controller
    }
    
    /**
     Albums 중 첫 번째 사진에 대해서 정상적으로 접근 가능한지 체크
     */
    func testAlbumsElementTouch(_ isNeedLaunch: Bool = true) {
        let app = XCUIApplication()
        if isNeedLaunch {
            app.launch()
        }
        
        let titleBtn = app.buttons["RootView.NaviTitleBtn"]
        titleBtn.tap() // move to Albums
        
        let albumsFirstChild = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        guard albumsFirstChild.exists else {
            NSLog("End testing")
            return
        }
        //albums의 첫 번째 element를 선택. view move
        albumsFirstChild.tap()
        
        let elementFirstChild = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        guard elementFirstChild.exists else {
            NSLog("End Testing in two")
            return
        }
        elementFirstChild.tap()
        //show Each Photo Display View Controller
    }
    
    /**
     display Tpye을 바꾸면서 각 collectionView에서 Each Photoview로 이동하는 테스트를 진행.
     */
    func testAppMoveControllers(_ isNeedLaunch: Bool = true) {
        let app = XCUIApplication()
        if isNeedLaunch {
            app.launch()
        }
        /**
         Albums 또는 Photos로 Switching 시키는 function
         */
        func photoOrAlbums(completion: () -> Void) {
            //default photos
            let titleBtn = app.buttons["RootView.NaviTitleBtn"]
            titleBtn.tap() // albums
            completion()
        }
        
        /**
         각각의 Photo에 대한 EachPhotoView에서의 Action 정의
         */
        func inEachPhotoView(completion: () -> Void) {
            app.buttons["Each.Back"].tap() // 뒤로 돌아감
            completion()
        }
        
        /**
         Collection View의 Type에 따라서 처리할 function
         */
        func cellElementTouch(completion: () -> Void, breaker: () -> Void) {
            //아래 코드는 RootViewController에서 default displayType이 변경 된 경우 각각이 다르게 동작해야 하기 때문에 이렇게 이용함.
            if app.collectionViews["RootView.CV.Square"].children(matching: .cell).element(boundBy: 0).exists {
                app.collectionViews["RootView.CV.Square"].children(matching: .cell).element(boundBy: 0).tap()
                //Photo가 나온다.
                inEachPhotoView{
                    completion()
                }
            }else if app.collectionViews["RootView.CV.Table"].children(matching: .cell).element(boundBy: 0).exists {
                app.collectionViews["RootView.CV.Table"].children(matching: .cell).element(boundBy: 0).tap()
                //해당 앨범의 Photo들만 나오는 view가 나온다.
                if app.collectionViews["Albums.CV"].children(matching: .cell).element(boundBy: 0).exists {
                    app.collectionViews["Albums.CV"].children(matching: .cell).element(boundBy: 0).tap()
                    //Photo가 나온다.
                    inEachPhotoView {
                        app.buttons["Albums.Back"].tap() // 뒤로 돌아감
                        completion()
                    }
                }else{
                    //Album의 element가 없다. 이 경우는 나올 수 없는 이유가 애초에 0개인 경우 나오지 않도록 코드상 구현.
                    NSLog("Album has no element")//문제 있음
                    breaker()
                }
            }else{
                //end?
                breaker()
            }
        }
        
        var count: Int = 0
        while(count < 5) {
            photoOrAlbums {
                cellElementTouch {
                    count += 1
                } breaker: {
                    count = 6 // break
                }
            }
        }
    }
    
    //MARK: - All functions Separated
    /**
     Photo Save Test
     */
    func photoSaveTest(_ isNeedLaunch: Bool = true) {
        let app = XCUIApplication()
        if isNeedLaunch {
            app.launch()
        }
        
        
        var counter : Int = 0
        while counter < 3 {
            self.navigationRootViewBarMove()
            self.selectCellInRootView {
                //여기는 Each Photoview가 나온 경우만 해당하게 된다.
                self.saveEditedPhotos {
                    if app.buttons["Albums.Back"].exists {
                        _ = app.buttons["Albums.Back"].waitForExistence(timeout: 0.5)
                        app.buttons["Albums.Back"].tap()
                    }
                } noCVElement: {
                    self.navigationEachPhotoViewMove()
                }
            } breaker: {
                counter = 4
            }
            counter += 1
        }
    }
    
    //MARK: Navigation Button들의 tap에대한 정의
    //CollectionView list change action in root view controller
    func navigationRootViewBarMove() {
        let app = XCUIApplication()
        app.buttons["RootView.NaviTitleBtn"].tap()
    }
    
    func navigationAlbumElementMove() {
        //back
        let app = XCUIApplication()
        app.buttons["Albums.Back"].tap()
    }
    
    func navigationEachPhotoViewMove() {
        //back
        let app = XCUIApplication()
        app.buttons["Each.Back"].tap()
    }
    
    
    //각 collectionView에서의 Action 정의
    func selectCellInRootView(completion: () -> Void, breaker: () -> Void) {
        let app = XCUIApplication()
        if app.collectionViews["RootView.CV.Square"].exists {
            let cell = app.collectionViews["RootView.CV.Square"].children(matching: .cell)
            let ranNum = Int.random(in: 0..<cell.count)
            if cell.element(boundBy: ranNum).exists {
                cell.element(boundBy: ranNum).tap()
                completion()
            }else{
                //cell.element(boundBy: 0).tap()
                breaker()
            }
        }else if app.collectionViews["RootView.CV.Table"].exists {
            let cell = app.collectionViews["RootView.CV.Table"].children(matching: .cell)
            let ranNum = Int.random(in: 0..<cell.count)
            if cell.element(boundBy: ranNum).exists {
                cell.element(boundBy: ranNum).tap()
                let cellAlbum = app.collectionViews["Albums.CV"].children(matching: .cell)
                let ranNumAlbum = Int.random(in: 0..<cellAlbum.count)
                if cellAlbum.element(boundBy: ranNumAlbum).e xists {
                    cellAlbum.element(boundBy: ranNumAlbum).tap()
                    completion()
                }else{
                    breaker()
                }
            }else{
                breaker()
            }
        }else{
            breaker()
        }
        /*
        if app.collectionViews["RootView.CV.Square"].children(matching: .cell).element(boundBy: 0).exists {
            app.collectionViews["RootView.CV.Square"].children(matching: .cell).element(boundBy: 0).tap()
            //Photo가 나온다.
            completion()
        }else if app.collectionViews["RootView.CV.Table"].children(matching: .cell).element(boundBy: 0).exists {
            app.collectionViews["RootView.CV.Table"].children(matching: .cell).element(boundBy: 0).tap()
            //해당 앨범의 Photo들만 나오는 view가 나온다.
            if app.collectionViews["Albums.CV"].children(matching: .cell).element(boundBy: 0).exists {
                app.collectionViews["Albums.CV"].children(matching: .cell).element(boundBy: 0).tap()
                //Photo가 나온다.
                completion()
            }else{
                //Album의 element가 없다. 이 경우는 나올 수 없는 이유가 애초에 0개인 경우 나오지 않도록 코드상 구현.
                NSLog("Album has no element")//문제 있음
                breaker()
            }
        }else{
            //end?
            breaker()
        }
        */
    }
    
    func saveEditedPhotos(completion: @escaping() -> Void, noCVElement: () -> Void) {
        //Each.CV
        let app = XCUIApplication()
        if app.collectionViews["Each.CV"].children(matching: .cell).count != 0 {
            let num = Int.random(in: 0 ..< app.collectionViews["Each.CV"].children(matching: .cell).count)
            app.collectionViews["Each.CV"].children(matching: .cell).element(boundBy: num).tap()
            
            app.buttons["Each.Save"].tap()
            
            let alert = app.alerts["Each.Alert"]
            /*
            NSLog("HANDLER: \(alert)")
            NSLog("Buttons : \(alert.buttons)")
            NSLog("contain buttons : \(alert.buttons.element(boundBy: 0))")
            */
            let btn = app.buttons["Each.Check.Label"] //or Each.Check.Label // __representer
            _ = alert.waitForExistence(timeout: 2)
            btn.tap()
            completion()
            //아래는 label외에 깔끔하게 할 방법 찾기 위해 임시 주석.
            /*
            let predicate = NSPredicate(format: "exists == 1")
            expectation(for: predicate, evaluatedWith: alert) { () -> Bool in
                NSLog("HANDLER: \(alert)")
                NSLog("Buttons : \(alert.buttons)")
                NSLog("contain buttons : \(alert.buttons.element(boundBy: 0))")
                return true
            }
            _ = alert.waitForExistence(timeout: 2)
            */
            
            /*
            let alert = app.alerts["Each.Alert"]
            _ = alert.waitForExistence(timeout: 2)
            
            alert.sheets.buttons["Each.Check.Label"].firstMatch.tap()
            */
            /*
            let alert = app.alerts["Each.Alert"]
            _ = alert.waitForExistence(timeout: 2)
            NSLog("ALERt : \(alert) ||\n\(alert.buttons)")
            let btn = alert.buttons[""]
            
            btn.tap()
            */
            
            /*
            addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
                alert.buttons["Each.Check"].tap()
                completion()
                return true
            }
            */
        }else{
            noCVElement()
        }
    }
}
