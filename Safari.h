#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>

@protocol MorphingDragImageDropTarget <NSObject>
- (unsigned int)morphingDragImage:(id)fp8 draggingEntered:(id)fp12;
- (unsigned int)morphingDragImage:(id)fp8 draggingUpdated:(id)fp12;
- (void)morphingDragImage:(id)fp8 draggingExited:(id)fp12;
- (BOOL)morphingDragImage:(id)fp8 performDragOperation:(id)fp12;
@end

@protocol ReopensAtLaunch
+ (void)reopen;
@end

@interface WindowController : NSWindowController
{
    NSString *_multiWindowFrameAutosaveName;
    BOOL _autosaveFrame;
    BOOL _lastResizeWasProgrammatic;
}

- (void)dealloc;
- (void)_saveFrameIfAllowed;
- (void)windowDidMove:(id)fp8;
- (void)windowDidResize:(id)fp8;
- (void)_safari_windowDidEndLiveResize;
- (void)_windowWillClose:(id)fp8;
- (BOOL)setMultiWindowFrameAutosaveName:(id)fp8;
- (id)multiWindowFrameAutosaveName;
- (void)_setFrameWithoutAutosaving:(struct _NSRect)fp8 programmatically:(BOOL)fp24;
- (void)setFrameWithoutAutosaving:(struct _NSRect)fp8;
- (void)setFrameProgrammatically:(struct _NSRect)fp8;
- (BOOL)lastResizeWasProgrammatic;
- (struct _NSRect)defaultFrame;
- (void)setFrameToDefault;
- (void)_windowDidLoad;
- (void)setFrameAutosaveEnabled:(BOOL)fp8;
- (BOOL)frameAutosaveEnabled;

@end

@interface TextFieldEditor : NSTextView
{
    BOOL _pasteReplacesLineEndingsWithSpaces;
}

- (id)init;
- (BOOL)pasteReplacesLineEndingsWithSpaces;
- (void)setPasteReplacesLineEndingsWithSpaces:(BOOL)fp8;
- (void)replaceCarriageReturnsAfterPaste;
- (void)paste:(id)fp8;

@end

@interface LocationFieldEditor : TextFieldEditor
{
@public
    NSTextField *field;
}

- (id)initWithField:(id)fp8;
- (unsigned int)validModesForFontPanel:(id)fp8;
- (void)changeFont:(id)fp8;
- (id)acceptableDragTypes;
- (unsigned int)draggingEntered:(id)fp8;
- (unsigned int)draggingUpdated:(id)fp8;
- (BOOL)prepareForDragOperation:(id)fp8;
- (BOOL)performDragOperation:(id)fp8;
- (void)concludeDragOperation:(id)fp8;
- (void)smartInsertForString:(id)fp8 replacingRange:(struct _NSRange)fp12 beforeString:(id *)fp20 afterString:(id *)fp24;

@end

@interface BrowserWindowController : WindowController <ReopensAtLaunch, MorphingDragImageDropTarget>
{
    id favoritesBarView;
    id tabBarView;
    id toggleBookmarksButton;
    NSTabView *tabSwitcher;
    id statusBar;
    id statusStringView;
    id _toolbarController;
    LocationFieldEditor* _locationFieldEditor;
    id _searchFieldEditor;
    id _completionController;
    id _searchSuggestionController;
    NSMenu *_dynamicBackMenu;
    NSMenu *_dynamicForwardMenu;
    BOOL _isLoading;
    BOOL _temporaryLocationBar;
    BOOL _editedLocationField;
    BOOL _editedLocationFieldWhileLoading;
    BOOL _focusedLocationFieldWhileLoading;
    BOOL _focusedSearchFieldWhileLoading;
    BOOL _tabBarHiddenByJavaScript;
    BOOL _readyToUpdateKeyboardLoop;
    NSMutableDictionary *_viewFramesForResizing;
    BOOL _favoritesBarShowing;
    BOOL _tabBarShowing;
    BOOL _statusBarShowing;
    BOOL _acceptsGenericIcon;
    NSString *_statusText;
    BOOL _clearStatus;
    BOOL _ellipsizeStatus;
    NSString *_newStatus;
    BOOL _stopAndReloadButtonWillStop;
    BOOL _tabBarInTransition;
    BOOL _tabBarShownForTabDrag;
    BOOL _confirmUnsubmittedFormText;
    BOOL _isAutoFilling;
    BOOL _usesHiDPIControls;
    NSTabView *_tabSwitcherForGoBack;
    NSTabView *_tabSwitcherForGoForward;
    unsigned int _coalescedUpdateMask;
    BOOL _performingCoalescedUpdates;
    NSURL *_pendingSearchURL;
    BOOL _RSSTransitionSlowMotion;
    id _RSSTransitionImageView;
    NSTimer *_RSSTransitionTimer;
    double _RSSTransitionStartTime;
    double _RSSTransitionDuration;
    BOOL _RSSTransitionInProgress;
    BOOL _startRSSAnimationAfterFirstLayout;
    id _closedWebViewHolder;
    NSTimer *_springToFrontTimer;
    NSTimer *_setStatusMessageTimer;
}

+ (int)windowPolicyFromEventModifierFlags:(unsigned int)fp8;
+ (int)windowPolicyFromEventModifierFlags:(unsigned int)fp8 requireCommandKey:(BOOL)fp12;
+ (int)windowPolicyFromCurrentEvent;
+ (int)windowPolicyFromCurrentEventRequireCommandKey:(BOOL)fp8;
+ (int)windowPolicyFromCurrentEventRespectingKeyEquivalents:(BOOL)fp8;
+ (void)reopen;
- (void)addBookmark:(id)fp8;
- (void)autoFill:(id)fp8;
- (void)changeTextEncoding:(id)fp8;
- (void)closeCurrentTab:(id)fp8;
- (void)closeInactiveTabs:(id)fp8;
- (void)goBack:(id)fp8;
- (void)goBackOrForwardFromSegmentedControl:(id)fp8;
- (void)goForward:(id)fp8;
- (void)goHome:(id)fp8;
- (void)goToToolbarLocation:(id)fp8;
- (void)makeTextLarger:(id)fp8;
- (void)makeTextSmaller:(id)fp8;
- (void)makeTextLargerOrSmallerFromSegmentedControl:(id)fp8;
- (void)makeTextStandardSize:(id)fp8;
- (void)moveCurrentTabToNewWindow:(id)fp8;
- (void)newBookmarkFolder:(id)fp8;
- (void)newTab:(id)fp8;
- (void)performQuickSearch:(id)fp8;
- (void)printFromToolbar:(id)fp8;
- (void)reportBugToApple:(id)fp8;
- (void)selectLocationField:(id)fp8;
- (void)selectNextTab:(id)fp8;
- (void)selectPreviousTab:(id)fp8;
- (void)selectSearchField:(id)fp8;
- (void)stopOrReload:(id)fp8;
- (void)stopLoading:(id)fp8;
- (void)reloadObeyingLocationField:(id)fp8;
- (void)closeTabFromMenu:(id)fp8;
- (void)closeOtherTabsFromMenu:(id)fp8;
- (void)moveTabToNewWindowFromMenu:(id)fp8;
- (void)reloadTabFromMenu:(id)fp8;
- (void)reloadAllTabs:(id)fp8;
- (void)showHistoryInBookmarksView:(id)fp8;
- (void)toggleLocationBar:(id)fp8;
- (void)toggleFavoritesBar:(id)fp8;
- (void)toggleStatusBar:(id)fp8;
- (void)toggleShowBookmarks:(id)fp8;
- (void)toggleTabBar:(id)fp8;
- (void)toggleShowGoogleSearch:(id)fp8;
- (BOOL)canReloadTab:(id)fp8;
- (BOOL)canReloadAllTabs;
- (BOOL)canCloseOrMoveTabs;
- (BOOL)canCreateNewTab;
- (void)noResponderFor:(SEL)fp8;
- (void)cancel:(id)fp8;
- (id)windowNibName;
- (void)windowWillLoad;
- (void)windowDidLoad;
- (void)showWindow:(id)fp8;
- (void)setDocument:(id)fp8;
- (BOOL)shouldCloseDocument;
- (struct _NSRect)defaultFrame;
- (BOOL)isLocationBarVisible;
- (void)setLocationBarVisible:(BOOL)fp8;
- (BOOL)isFavoritesBarVisible;
- (void)setFavoritesBarVisible:(BOOL)fp8;
- (BOOL)isTabBarVisible;
- (void)setTabBarVisible:(BOOL)fp8;
- (BOOL)isStatusBarVisible;
- (void)setStatusBarVisible:(BOOL)fp8;
- (BOOL)anyToolbarsVisible;
- (void)setToolbarsVisible:(BOOL)fp8;
- (struct _NSRect)adjustedFrameForSaving:(struct _NSRect)fp8;
- (struct _NSRect)adjustedFrameForCascade:(struct _NSRect)fp8 fromWindow:(id)fp24;
- (BOOL)isAvailableForForcedLocationUsingWindowPolicy:(int)fp8;
- (BOOL)allowBookmarksChanges;
- (void)editAddressOfFavorite:(id)fp8;
- (void)editContentsOfFavorite:(id)fp8;
- (void)editTitleOfFavorite:(id)fp8;
- (void)revealFavorite:(id)fp8;
- (void)deleteBookmark:(id)fp8;
- (void)editTitleOfBookmarksCollection:(id)fp8;
- (BOOL)acceptsGenericIcon;
- (void)setAcceptsGenericIcon:(BOOL)fp8;
- (void)setSearchFieldText:(id)fp8;
- (void)_searchForStringWithoutUpdatingRecentSearches:(id)fp8;
- (void)searchForString:(id)fp8;
- (BOOL)toolbarInputFieldsIncludeSearchField;
- (id)dynamicBackMenu;
- (id)dynamicForwardMenu;
- (BOOL)usesHiDPIControls;
- (id)tabBarView;
- (id)orderedTabs;
- (id)orderedTabViewItems;
- (id)currentWebView;
- (id)selectedTab;
- (unsigned int)selectedTabIndex;
- (id)createTab;
- (id)createTabWithFrameName:(id)fp8;
- (id)createTabWithFrameName:(id)fp8 andShow:(BOOL)fp12 addToRightSide:(BOOL)fp16;
- (id)createInactiveTab;
- (id)createInactiveTabWithFrameName:(id)fp8;
- (id)createTabWithWebView:(id)fp8 andShow:(BOOL)fp12 addToRightSide:(BOOL)fp16;
- (void)selectTab:(id)fp8;
- (void)closeTab:(id)fp8;
- (void)closeTabOrWindow:(id)fp8;
- (void)closeOtherTabs:(id)fp8;
- (void)reloadTabsMatchingURLs:(id)fp8;
- (void)replaceTabURLs:(id)fp8 usingTabLabels:(id)fp12 allowGoBack:(BOOL)fp16;
- (void)replaceEmptyTabWithTabs:(id)fp8;
- (void)moveTabFromOtherWindow:(id)fp8 toIndex:(unsigned int)fp12 andShow:(BOOL)fp16;
- (id)tabsWithUnsubmittedFormText;
- (unsigned int)numberOfNonEmptyTabs;
- (void)updateTabLabelForWebView:(id)fp8;
- (float)tabBarHeight;
- (void)windowTitleNeedsUpdate;
- (void)firstResponderMightHaveChanged;
- (id)windowForSheet;
- (BOOL)isAutoFilling;
- (BOOL)canShowInputFields;
- (BOOL)validateUserInterfaceItem:(id)fp8;
- (BOOL)validateMenuItem:(id)fp8;
- (void)windowDidBecomeKey:(id)fp8;
- (void)windowDidResignKey:(id)fp8;
- (struct _NSSize)windowWillResize:(id)fp8 toSize:(struct _NSSize)fp12;
- (void)windowDidResize:(id)fp8;
- (void)_safari_windowDidEndLiveResize;
- (void)windowDidMove:(id)fp8;
- (void)windowDidMiniaturize:(id)fp8;
- (void)windowDidDeminiaturize:(id)fp8;
- (struct _NSRect)windowWillUseStandardFrame:(id)fp8 defaultFrame:(struct _NSRect)fp12;
- (BOOL)window:(id)fp8 willHandleKeyEvent:(id)fp12;
- (BOOL)window:(id)fp8 willHandleMouseDownEvent:(id)fp12;
- (id)windowWillReturnFieldEditor:(id)fp8 toObject:(id)fp12;
- (BOOL)windowShouldClose:(id)fp8;
- (void)_windowWillClose:(id)fp8;
- (void)windowWillClose:(id)fp8;
- (id)windowTitleBarURL;
- (void)windowShouldGoToURL:(id)fp8;
- (void)controlTextDidChange:(id)fp8;
- (void)controlTextDidEndEditing:(id)fp8;
- (BOOL)control:(id)fp8 textView:(id)fp12 doCommandBySelector:(SEL)fp16;
- (void)locationTextFieldURLDropped:(id)fp8;
- (id)bookmarkTitleForLocationField:(id)fp8;
- (BOOL)searchField:(id)fp8 shouldRememberSearchString:(id)fp12;
- (void)textFieldWithControlsPerformRightButtonAction:(id)fp8;
- (void)textFieldWithControlsPerformRightButton2Action:(id)fp8;
- (void)textFieldWithControls:(id)fp8 mouseUpInRightButton:(id)fp12;
- (BOOL)textFieldWithControls:(id)fp8 mouseDownInRightButton2:(id)fp12;
- (void)textFieldWithControls:(id)fp8 mouseUpInRightButton2:(id)fp12;
- (void)menuNeedsUpdate:(id)fp8;
- (BOOL)menuHasKeyEquivalent:(id)fp8 forEvent:(id)fp12 target:(id *)fp16 action:(SEL *)fp20;
- (id)targetForSearch;
- (unsigned int)morphingDragImage:(id)fp8 draggingEntered:(id)fp12;
- (unsigned int)morphingDragImage:(id)fp8 draggingUpdated:(id)fp12;
- (void)morphingDragImage:(id)fp8 draggingExited:(id)fp12;
- (BOOL)morphingDragImage:(id)fp8 performDragOperation:(id)fp12;
- (void)morphingDragImage:(id)fp8 enteredWindow:(id)fp12;
- (void)morphingDragImage:(id)fp8 exitedWindow:(id)fp12;
- (void)willSelectTabViewItem;
- (void)didSelectTabViewItem;
- (void)tabBarViewDidRearrangeTabs;
- (void)updateProgressBar:(BOOL)fp8;
- (void)webViewSheetRequestStatusHasChanged:(id)fp8;
- (void)webViewStatusMessageHasChanged:(id)fp8;
- (void)webViewLocationFieldURLHasChanged:(id)fp8;
- (void)webViewLocationFieldIconHasChanged:(id)fp8;
- (void)webViewMainDocumentHasLoaded:(id)fp8;
- (void)webViewPageForSnapBackHasChanged:(id)fp8;
- (void)webViewLoadingStatusHasChanged:(id)fp8;
- (void)webViewProgressFinished:(id)fp8;
- (void)webViewNameHasChanged:(id)fp8;
- (void)webViewBannerHasChanged:(id)fp8;
- (void)webViewFormEditedStatusHasChanged:(id)fp8;
- (void)webViewBlockedFromKeyViewLoopHasChanged:(id)fp8;
- (void)webFrameLoadStarted:(id)fp8;
- (void)webFrameLoadCommitted:(id)fp8;
- (void)webFrameLoadDidFirstLayout:(id)fp8;
- (void)webFrameLoadFinished:(id)fp8 withError:(id)fp12;
- (void)webFrame:(id)fp8 willPerformClientRedirectToURL:(id)fp12;
- (void)dealloc;

@end
