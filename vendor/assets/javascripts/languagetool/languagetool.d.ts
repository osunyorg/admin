/// <reference types="firefox-webext-browser" />
/// <reference types="w3c-css-typed-object-model-level-1" />
interface Window {
    /**
     * Object which give access to extension API, available only on chrome browser.
     */
    chrome: typeof browser | undefined;
    /**
     * see smoothscroll.js
     */
    scrollRangeIntoView: (range: Range, options: {
        behavior?: "smooth";
        block: ScrollIntoViewOptions['block'];
    }) => void;
    /**
     * Singleton instance of LTAssistant.
     */
    ltAssistant: LTAssistant | null;
    /**
     * Is extension content scripts (js files) loaded.
     */
    __ltJsLoaded: boolean | null;
    /**
     * Is extension content scripts (css files) loaded.
     */
    __ltCssLoaded: boolean | null;
    /**
     * Currently active element.
     */
    __ltLastActiveElement: HTMLElement | null;
}
/**
 * Pseudo-type for contenteditable element.
 */
declare type CEElement = HTMLElement;
/**
 * Pseudo-type for input element with text.
 */
declare type TextArea = HTMLTextAreaElement;
/**
 * Pseudo-type for input element with text.
 */
declare type TextInput = HTMLInputElement;
/**
 * Represent any input area (contenteditable element, textarera or input) which can be validated.
 */
declare type InputArea = CEElement | TextArea | TextInput;
/**
 * Represent DOM node with nodeType = TEXT_NODE.
 */
declare type TextNode = Text;
/**
 * Pseudo type for block DOM element.
 */
declare type HTMLBlockElement = HTMLElement;
/**
 * Represent two dimensional size.
 */
interface Size {
    /**
     * Width.
     */
    width: number;
    /**
     * Height.
     */
    height: number;
}
/**
 * Represent point in two-dimensional space.
 */
interface Point {
    /**
     * X coordinate.
     */
    x: number;
    /**
     * Y coordinate.
     */
    y: number;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
declare const config: {
    /**
     * Duration of time interval (in milliseconds) between the extension health checks.
     */
    EXTENSION_HEALTH_RECHECK_INTERVAL: number;
    /**
     * Duration of time interval (in milliseconds) between browser UI mode (dark/light) checks.
     */
    UI_MODE_RECHECK_INTERVAL: number;
    /**
     * Duration of time interval (in milliseconds) between account status (basic/premium) checks.
     */
    ACCOUNT_STATUS_RECHECK_INTERVAL: number;
    /**
     * Duration of time interval (in milliseconds) between reloading of external configuration.
     */
    EXTERNAL_CONFIG_RELOAD_INTERVAL: number;
    /**
     * Duration of time interval (in milliseconds) between reloading of external configuration.
     */
    PING_INTERVAL: number;
    /**
     * Duration of time interval (in milliseconds) between checks that iframe is initialized properly.
     */
    IFRAME_INITILIZATION_RECHECK_INTERVAL: number;
    /**
     * How often the dictionary should be synced
     */
    DICTIONARY_SYNC_INTERVAL: number;
    /**
     * Duration of time interval (in milliseconds) between renders of extension UI elements.
     */
    RENDER_INTERVAL: number;
    /**
     * Duration of time interval (in milliseconds) between checks of extension UI elements.
     */
    TOOLBAR_DECREASE_SIZE_INTERVAL: number;
    /**
     * Waiting time (in milliseconds) for the completion of the validaion request.
     */
    VALIDATION_REQUEST_TIMEOUT: number;
    /**
     * URL of the page which should be displayed after the extension is installed.
     */
    INSTALL_URL: string;
    /**
     * URL of the page which should be displayed after the extension is uninstalled.
     */
    UNINSTALL_URL: string;
    /**
     * URL of main (for LT basic) validation endpoint.
     */
    MAIN_SERVER_URL: string;
    /**
     * URL of main (for LT basic) fallback validation endpoint.
     */
    MAIN_FALLBACK_SERVER_URL: string;
    /**
     * URL of premium (for LT premium) validation endpoint.
     */
    PREMIUM_SERVER_URL: string;
    /**
     * URL of premium (for LT premium) fallback validation endpoint.
     */
    PREMIUM_FALLBACK_SERVER_URL: string;
    /**
     * URL of local validation endpoint.
     */
    LOCAL_SERVER_URL: string;
    /**
     * URL of feedback endpoint.
     */
    FEEDBACK_SERVER_URL: string;
    /**
     * URL of external configuration file.
     */
    EXTERNAL_CONFIG_URL: string;
    /**
     * URL of ping endpoint
     */
    PING_URL: string;
    /**
     * Error codes after which extension should switch to fallback endpoint.
     */
    SWITCH_TO_FALLBACK_SERVER_ERRORS: number[];
    /**
     * Duration of time interval (in milliseconds) between checks of main server availability.
     */
    MAIN_SERVER_RECHECK_INTERVAL: number;
    /**
     * Minimum text length required for validation.
     */
    MIN_TEXT_LENGTH: number;
    /**
     * Maximum text length supported by LT Basic.
     */
    MAX_TEXT_LENGTH: number;
    /**
     * Maximum text length supported by LT Premium.
     */
    MAX_TEXT_LENGTH_PREMIUM: number;
    /**
     * Maximum text length supported by LT custom server.
     */
    MAX_TEXT_LENGTH_CUSTOM_SERVER: number;
    /**
     * Optimal text length for partial validation request.
     */
    PARTIAL_VALIDATION_CHUNK_LENGTH: number;
    /**
     * Delay (in milliseconds) between text changing and sending text validation request.
     */
    VALIDATION_DELAY: number;
    /**
     * Maximum delay (in milliseconds) between text changing and sending text validation request.
     */
    VALIDATION_MAX_DELAY: number;
    /**
     * Time interval that must pass after text changing to be allowed to complete typing mode.
     */
    STOPPED_TYPING_TIMEOUT: number;
    COLORS: {
        GRAMMAR: {
            UNDERLINE: string;
            BACKGROUND: string;
            EMPHASIZE: string;
            TITLE: string;
        };
        STYLE: {
            UNDERLINE: string;
            BACKGROUND: string;
            EMPHASIZE: string;
            TITLE: string;
        };
        SPELLING: {
            UNDERLINE: string;
            BACKGROUND: string;
            EMPHASIZE: string;
            TITLE: string;
        };
        SYNONYMS: {
            UNDERLINE: string;
        };
    };
    /**
     * Maximum number of error fixes that can be displayed.
     */
    MAX_FIXES_COUNT: number;
    /**
     * Maximum errors count that should be reported per session.
     */
    MAX_EXCEPTION_COUNT: number;
    MAX_USAGE_COUNT_ONBOARDING: number;
    SUPPORTED_SYNONYM_LANGUAGES: string[];
};
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
 * Allow to get info about current browser.
 */
declare class BrowserDetector {
    /**
     * Is current browser is Chromium based.
     */
    private static _isChromium;
    /**
     * Is current browser Google Chrome.
     */
    private static _isChrome;
    /**
     * Is current browser Firefox.
     */
    private static _isFirefox;
    /**
     * Is current browser Opera.
     */
    private static _isOpera;
    /**
     * Is current browser old Edge.
     */
    private static _isOldEdge;
    /**
     * Is current browser Edge.
     */
    private static _isEdge;
    /**
     * Is current browser Safari.
     */
    private static _isSafari;
    /**
     * Is current browser Trident.
     */
    private static _isTrident;
    /**
     * Is current browser Yandex.Browser.
     */
    private static _isYaBrowser;
    /**
     * Is current browser unsupported Chrome.
     */
    private static _isUnsupportedChrome;
    /**
     * Is current browser unsupported Firefox.
     */
    private static _isUnsupportedFirefox;
    /**
     * Is BrowserDetector initialized.
     */
    private static _isInitialized;
    /**
     * Init BrowserDetector. There is no need to use it in external code.
     */
    static _contructor(): void;
    static getOS(): "Mac" | "Windows" | "CrOS" | "Linux" | "Other";
    /**
     * Is current browser is Chromium based.
     */
    static isChromium(): boolean;
    /**
     * Is current browser Google Chrome.
     */
    static isChrome(): boolean;
    /**
     * Is current browser Firefox.
     */
    static isFirefox(): boolean;
    /**
     * Is current browser Opera.
     */
    static isOpera(): boolean;
    /**
     * Is current browser Edge.
     */
    static isEdge(): boolean;
    /**
     * Is current browser Trident.
     */
    static isTrident(): boolean;
    /**
     * Is current browser Safari.
     */
    static isSafari(): boolean;
    /**
     * Is current browser Yandex.Browser.
     */
    static isYaBrowser(): boolean;
    /**
     * Is current browser unsupported Chrome.
     */
    static isUnsupportedChrome(): boolean;
    /**
     * Is current browser unsupported Firefox.
     */
    static isUnsupportedFirefox(): boolean;
    /**
     * Is current browser unsupported.
     */
    static isUnsupportedBrowser(): boolean;
    /**
     * Return current browser name.
     */
    static getBrowserName(): string;
    /**
     * Return user browser agent id.
     */
    static getUserAgentIdentifier(): string;
}
interface LocalStorageItem {
    key: string;
    value: any;
}
declare class LocalStorageWrapper {
    private static ROOT_KEY;
    private static MAX_BYTE_SIZE;
    static set(key: string, value: any): void;
    static get<T>(key: string): T | null;
    static getAll(): LocalStorageItem[];
    static remove(key: string): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
 * Represent operation which can be canceled.
 */
interface CancellationToken {
    /**
     * Cancel operation and free resources.
     */
    destroy: () => void;
}
/**
 * Data for translation.
 */
interface TranslationData {
    /**
     * Message key.
     */
    key: string;
    /**
     * Should html content of element be translated.
     */
    isHTML?: boolean;
    /**
     * Name of element attribute which value should be translated.
     */
    attr?: string;
    /**
     * Substitution values for translated message.
     */
    interpolations?: (string | number)[];
}
/**
 * Check if element is CEElement (contenteditable element).
 *
 * @param element - Checked element.
 */
declare function isCEElement(element: InputArea): element is CEElement;
/**
 * Check if element is input or textarea
 *
 * @param element - Checked element.
 */
declare function isFormElement(element: HTMLElement): element is TextArea | TextInput;
/**
 * Check if element is TextArea.
 *
 * @param element - Checked element.
 */
declare function isTextArea(element: InputArea): element is TextArea;
/**
 * Check if element is TextInput.
 *
 * @param element - Checked element.
 */
declare function isTextInput(element: InputArea): element is TextInput;
/**
 * Check if node is HTMLElement.
 *
 * @param node - Checked node.
 */
declare function isElementNode(node: Node): node is HTMLElement;
/**
 * Check if node is TextNode.
 *
 * @param node - Checked node.
 */
declare function isTextNode(node: Node): node is TextNode;
/******************************************************************************************/
/****************************** Custom timeouts and intervals *****************************/
/******************************************************************************************/
/**
 * Return promise which will be resolved after specified timeout.
 *
 * @param timeout - Timeout in milliseconds, default is 25.
 * @param data - Data which should be passed to resolve, default is null.
 */
declare function wait<T>(timeout?: number, data?: T | null): Promise<T | null>;
/**
 * Invoke callback function at next animation frame, but not before specified timeout.
 *
 * @param callback - Callback function.
 * @param timeout - Timeout in milliseconds.
 */
declare function setAnimationFrameTimeout(callback: Function, timeout: number): CancellationToken;
/**
 * Invoke callback function at animation frames, with specified interval between each invoсation.
 *
 * @param callback - Callback function.
 * @param interval - Interval in milliseconds between each invocation.
 */
declare function setAnimationFrameInterval(callback: Function, interval: number): CancellationToken;
/******************************************************************************************/
/**************************************** Geometry ****************************************/
/******************************************************************************************/
/**
 * Check if two segments (a1; a2) and (b1; b2) intersect.
 *
 * @param a1 - Start point of first segment.
 * @param a2 - End point of first segment.
 * @param b1 - Start point of second segment.
 * @param b2 - End point of secong point.
 * @param withBounds - Should segments be treated as closed or opened, default is false.
 */
declare function isIntersect(a1: number, a2: number, b1: number, b2: number, withBounds?: boolean): boolean;
/**
 * Check if two rectangles are equal.
 *
 * @param rect1 - First rectangle.
 * @param rect2 - Second rectangle.
 */
declare function isRectsEqual(rect1: RectInterface, rect2: RectInterface): boolean;
/**
 * Check if second rectangle contains in first rectangle.
 *
 * @param rect1 - First rectangle.
 * @param rect2 - Second rectangle.
 */
declare function isRectContainsRect(rect1: RectInterface, rect2: RectInterface): boolean;
/**
 * Check if two rectangles intersect.
 *
 * @param rect1 - First rectangle.
 * @param rect2 - Second rectangle.
 */
declare function isRectsIntersect(rect1: RectInterface, rect2: RectInterface): boolean;
/**
 * Check if point is inside rectangle.
 *
 * @param rect - Rectangle for checking.
 * @param point - Checked point.
 */
declare function isPointInsideRect(rect: RectInterface, point: Point): boolean;
/**
 * Check if point is inside rectangle.
 *
 * @param rect - Rectangle for checking.
 * @param x - Point X coordinate.
 * @param y - Point Y coordinate.
 */
declare function isPointInsideRect(rect: RectInterface, x: number, y: number): boolean;
/******************************************************************************************/
/****************************************** HTML ******************************************/
/******************************************************************************************/
/**
 * Check if node2 contains inside node2 (native .contains also returns true when it's the same element).
 *
 * @param node1 - Possible parent element.
 * @param node2 - Possible child element.
 */
declare function contains(node1: Node, node2: Node): boolean;
/**
 * Check if parent contains inside node which satisfied specified selector.
 *
 * @param parent - Possible parent element.
 * @param selector - CSS selector to which a nested node must satisfy.
 */
declare function contains(parent: Element, selector: string): boolean;
/**
 * Returns the first (starting at element) inclusive ancestor that matches selectors, and null otherwise.
 *
 * @param element - Starting element.
 * @param selector - Match selector.
 */
declare function closestElement(element: Element, selector: string): Element | null;
/**
 * Returns element in which the window is embedded, or null if the element is either top-level or is embedded into a document with a different script origin; that is, in cross-origin situations.
 *
 * @param win - Window.
 */
declare function getFrameElement(win: Window): HTMLElement | null;
/**
 * Checks if an element is scrollable.
 *
 * @param element - HTML element.
 */
declare function isScrollable(element: HTMLElement): boolean;
/**
 * Check if element owner document has firefox design mode.
 *
 * @param element - Checked element.
 */
declare function hasFirefoxDesignMode(element: InputArea): boolean;
/**
 * Check if element has focus.
 *
 * @param element - Checked element.
 */
declare function hasFocus(element: InputArea): boolean;
/**
 * Return vertical position of first and last visible pixels.
 */
declare const getVisibleTopAndBottom: (element: HTMLElement, domMeasurement: DomMeasurement, clientHeight: number, ignoreSelector: string) => {
    top: number;
    bottom: number;
};
/**
 * Check if element is visible.
 *
 * @param element - Checking element.
 */
declare function isVisible(element: HTMLElement): boolean;
/**
 * Gradually hide element.
 *
 * @param element - Hiding element.
 * @param callback - Function, which will be invoked at the end.
 */
declare function fadeOut(element: HTMLElement, callback?: Function): void;
/**
 * Gradually hide element and then remove it.
 *
 * @param element - Hiding element.
 * @param callback - Function, which will be invoked at the end.
 */
declare function fadeOutAndRemove(element: HTMLElement, callback?: Function): void;
/******************************************************************************************/
/***************************************** Events *****************************************/
/******************************************************************************************/
/**
 * Dispatch custom event with passed name and details.
 *
 * @param eventName - Event name.
 * @param detail - Custom event details.
 */
declare function dispatchCustomEvent(element: Document | HTMLElement, eventName: string, detail?: Object): void;
/**
 * Invoke callback function if specified event fired on any element contains inside target element.
 *
 * @param element - Target element.
 * @param eventName - Event name.
 * @param callback - Event handler.
 */
declare function addUseCaptureEvent(element: HTMLDocument | HTMLElement, eventName: string, callback: (event: Event) => void): CancellationToken;
/**
 * Add event listener on scroll event for each element ancestors that could have scrollbar.
 *
 * @param element - Target element.
 * @param callback - Event handler.
 */
declare function observeScrollableAncestors(element: HTMLElement, callback: Function): CancellationToken;
interface ObserverItem {
    element: HTMLElement;
    callback: (e: HTMLElement) => void;
}
/**
 * Watching TextArea and invoke callback function when it becomes disabled (receives readOnly=true, disabled=true or will be hidden).
 */
declare const onElementDisabled: (element: HTMLElement, callback: (e: HTMLElement) => void) => void;
/**
 * Watching TextArea and invoke callback function when it removed from DOM tree.
 */
declare const onElementRemoved: (element: HTMLElement, callback: (e: HTMLElement) => void) => void;
/******************************************************************************************/
/****************************************** Text ******************************************/
/******************************************************************************************/
/**
 * Represent info for extended word in text.
 */
interface WordContextInfo {
    /**
     * Word (can be hyphenated word).
     */
    word: string;
    /**
     * Word position in text.
     */
    position: {
        /**
         * Start position.
         */
        start: number;
        /**
         * End position.
         */
        end: number;
    };
    beforeText: string;
    afterText: string;
}
interface TextPartMap {
    offset: number;
    originalOffset: number;
    text: string;
    length: number;
}
interface TextSubset {
    text: string;
    originalText: string;
    partsMap: TextPartMap[];
}
/**
 * Information on differences between two texts.
 */
interface TextDiff {
    /**
     * Index of the beginning of changes in the text.
     */
    from: number;
    /**
     * Removed text fragment.
     */
    oldFragment: string;
    /**
     * Added text fragment.
     */
    newFragment: string;
}
/**
 * Information on differences between two paragraphs in text.
 */
interface ParagraphDiff {
    /**
     * Paragraph text in original text. Can be null if associated paragraph added.
     */
    oldText: string | null;
    /**
     * Paragraph text in new text. Can be null if associated paragraph removed.
     */
    newText: string | null;
    /**
     * Paragraph offset in original text.
     */
    oldOffset: number;
    /**
     * Paragraph offset in new text.
     */
    newOffset: number;
    /**
     * Differences between paragraphs texts. Can be null if both paragraphs has equal text.
     */
    textDiff: TextDiff | null;
}
declare let getWordPosition: (text: string, start: number, end: number) => {
    start: number;
    end: number;
} | null;
/**
 * Return extended word (word with hyphen, like e-mail) info for selected text. Return null if there is no word.
 *
 * @param text - Total text.
 * @param start - Start position of selected word.
 * @param end - End position of selected word.
 * @param beforeWordsCount - Count of words in context before selected word.
 * @param afterWordsCount - Count of words in context after selected word.
 */
declare let getWordContext: (text: string, start: number, end: number, beforeWordsCount?: number, afterWordsCount?: number) => WordContextInfo | null;
declare function getValuableText(originalText: string, replacedParts: ReplacedPart[]): TextSubset;
/**
 * Find difference between two texts, return null if both texts are equal.
 *
 * @param oldText - Original text.
 * @param newText - New text.
 */
declare function getTextsDiff(oldText: string, newText: string): TextDiff | null;
/**
 * Check is two texts haven't even one equal paragraph.
 *
 * @param oldText - Old text.
 * @param newText - New text.
 */
declare function isTextsCompletelyDifferent(oldText: string, newText: string): boolean;
/**
 * Compare texts and find changed paragraphs (text or offset).
 *
 * @param oldText - Original text.
 * @param newText - New text.
 */
declare function getParagraphsDiff(oldText: string, newText: string): ParagraphDiff[];
/**
 * Return all matches of regExp in specified text.
 *
 * @param text - Text to search for matches.
 * @param regExp - Regular expression.
 * @param from - Start index.
 */
declare function matchAll(text: string, regExp: RegExp, from?: number): RegExpExecArray[];
/**
 * Determines if the word is capitalized.
 *
 * @param str
 */
declare function isCapitalized(str: string): boolean;
declare function includesWhiteSpace(str: string): boolean;
declare let isWhitespace: (char: string) => boolean;
declare let normalizeWhitespaces: (text: string) => string;
declare let isZWC: (char: string) => boolean;
declare let indexOfZWC: (text: string) => number;
declare let removeZWC: (text: string) => string;
/******************************************************************************************/
/*************************************** Translation **************************************/
/******************************************************************************************/
/**
 * Translate element specified by selector.
 *
 * @param selector - Query selector of element.
 * @param key - Message key used in translation.
 */
declare function translateElement(selector: string, key: string): void;
/**
 * Translate element specified by selector.
 *
 * @param selector - Query selector of element.
 * @param data - Data used in translation.
 */
declare function translateElement(selector: string, data: TranslationData): void;
/**
 * Translate element.
 *
 * @param element - HTML element for translation.
 * @param key - Message key used in translation.
 */
declare function translateElement(element: HTMLElement, key: string): void;
/**
 * Translate element.
 *
 * @param element - HTML element for translation.
 * @param data - Data used in translation.
 */
declare function translateElement(element: HTMLElement, data: TranslationData): void;
/**
 * Translate all elements inside container.
 *
 * @param container - Container, which childs should be translated.
 */
declare function translateSection(container: HTMLElement): void;
/******************************************************************************************/
/***************************************** Common *****************************************/
/******************************************************************************************/
/**
 * Return array of items withoud duplicates.
 *
 * @param arr - Array of items.
 */
declare function uniq<T>(arr: T[]): T[];
/**
 * Check if both objects are the same.
 *
 * @param obj1 - First object.
 * @param obj2 - Second object.
 */
declare function isSameObjects(obj1: any, obj2: any): boolean;
/**
 * Deep clone value. Support primitives, date, regexp, array, object.
 *
 * @param value - Value for cloning.
 */
declare function clone<T>(value: T): T;
/**
 * A function that periodically checks if a certain value becomes truthy, if so, it resolves the returned promise.
 *
 * @param callback - Function that gets called. If it returns a truthy value the promise is resolved
 * @param interval - How often the function should be called
 * @param maxTryCount - The maximum amount of calls to that function, before rejecting
 */
declare function waitFor<T>(callback: () => T | null | undefined, interval?: number, maxTryCount?: number): Promise<T>;
/**
 * Return range for document fragment under specified point.
 *
 * @param point - Point on document.
 */
declare function getRangeAtPoint(point: Point): Range | null;
/**
 * Find out if two ranges are equal.
 *
 * @param range1 - First range.
 * @param range2 - Second range.
 */
declare function isSameRange(range1: Range | null, range2: Range | null): boolean;
/**
 * Return text selected by user.
 */
declare function getSelectedText(): string;
/**
 * Asynchronously load content of html file from extension package.
 *
 * @param path - Path to html file.
 */
declare function loadHTML(path: string): Promise<string>;
/**
 * Load specified css file from extension package in context of current page.
 *
 * @param path - Path to css file.
 */
declare function loadStylesheet(path: string): void;
/**
 * Create style tag with specified rules.
 *
 * @param content - CSS rules.
 */
declare function createStylesheet(content: string): HTMLStyleElement;
/**
 * Generate stack trace info for error.
 *
 * @param error - Error.
 */
declare function generateStackTrace(error: Error | ValidationError): string | undefined;
/**
 * Check is extension available on current page.
 *
 * @param win - Main window.
 */
declare function isLTAvailable(win: Window): boolean;
/**
 * Check if css content scripts are loaded
 *
 * @param win - Window.
 */
declare function isCssContentScriptsLoaded(win: Window): boolean;
declare function getCountdown(expires: number): string;
declare function pad(num: number): string;
/**
 * Start OAuth Login Flow.
 *
 * @param loginUrl - URL where the user can log in.
 */
declare function goToManagedLogin(loginUrl: string, callback: (email: string, token: string) => void): void;
/**
 * Converts a data uri to a blob.
 *
 * @param dataURI - Data uri to convert.
 */
declare function dataURItoBlob(dataURI: string): Blob;
declare const getColorLuminosity: (color: string | [number, number, number] | [number, number, number, number]) => number;
/******************************************************************************************/
/************************************** Editor tests **************************************/
/******************************************************************************************/
/**
 * Check if contenteditable element is TinyMCE editor.
 *
 * @param element - Target element.
 */
declare function isTinyMCE(element: CEElement): boolean;
/**
 * Check if contenteditable element is TinyMCE editor.
 *
 * @param element - Target element.
 */
declare function isCKEditor(element: CEElement): boolean;
/**
 * Check if contenteditable element is Slate editor.
 *
 * @param element - Target element.
 */
declare function isSlateEditor(element: CEElement): boolean;
/**
 * Check if contenteditable element is Quill editor.
 *
 * @param element - Target element.
 */
declare function isQuillEditor(element: CEElement): boolean;
/**
 * Check if contenteditable element is ProseMirror
 *
 * @param element - Target element.
 */
declare function isProseMirror(element: CEElement): boolean;
/**
 * Check if contenteditable element is Gutenberg editor.
 *
 * @param element - Target element
 */
declare function isGutenberg(element: CEElement): boolean;
/**
 * Check if contenteditable element is Trix editor.
 *
 * @param element - Target element
 */
declare function isTrixEditor(element: CEElement): boolean;
/**
 * Check if contenteditable element is Google Docs editor.
 *
 * @param element - Target element
 */
declare function isGoogleDocsEditor(element: CEElement): boolean;
/**
 * Check if contenteditable element is the LT Editor
 *
 * @param element - Target element
 */
declare function isLTEditor(element: any): boolean;
/******************************************************************************************/
/******************************************* URL ******************************************/
/******************************************************************************************/
/**
 * Get URL of current page.
 */
declare function getCurrentUrl(): string;
/**
 * Get hostname from URL.
 *
 * @param url - URL.
 */
declare function getDomain(url: string, defaultValue?: string): string;
/**
 * Get domain of current page.
 */
declare function getCurrentDomain(): string;
/**
 * Get URL of main page.
 */
declare function getMainPageDomain(): string;
/**
 * Get list of subdomains for specified domain. Subdomains contains from less common to most common.
 *
 * @param domain - Domain.
 */
declare function getSubdomains(domain: string): string[];
declare function hasTextNodeChildWithContent(element: Element): boolean;
/**
 * Check is text starts with uppercase letter.
 *
 * @param text - Checked text.
 */
declare function startsWithUppercase(text: string): boolean;
/**
 * Convert first letter to lowercase.
 *
 * @param text - Convertible text.
 */
declare function toLowercaseFirstChar(text: string): string;
/**
 * Check is error should be ignored because misspelled word contains in dictionary.
 *
 * @param error - Checked error.
 * @param dictionary - User dictionary.
 */
declare function isErrorIgnoredByDictionary(error: TextError, dictionary: string[]): boolean;
/**
 * Checks if a string is all-uppercase
 *
 * @param str word to check
 */
declare const isAllUppercase: (str: string) => boolean;
/**
 * Check is error should be ignored because error rule is ignored.
 *
 * @param error - Checked error.
 * @param ignoredRules - List of ignored rules.
 */
declare function isErrorRuleIgnored(error: TextError, ignoredRules: IgnoredRule[]): boolean;
/**
 * escapes html
 */
declare function escapeHTML(str: string): string;
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
* Base implementation for event communication (publisher/subscriber pattern).
*/
declare class EventBus {
    /**
     * Event handlers.
     */
    private _eventHandlers;
    /**
     * Initialize new instance.
     */
    constructor();
    /**
     * Subscribe to event with specified name.
     *
     * @param eventName - Event name.
     * @param listener - Event handler.
     */
    subscribe(eventName: string, listener: (data: any) => void): void;
    /**
     * Invoke each event handler subscribed to event with specified name,
     * pass data to event handler as parameter.
     *
     * @param eventName - Event name.
     * @param data - Event args.
     */
    fire(eventName: string, data?: any): void;
    /**
     * Unsubscribe all event handlers.
     */
    destroy(): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
interface RectInterface {
    top: number;
    right: number;
    bottom: number;
    left: number;
}
interface BoxInterface extends RectInterface {
    width: number;
    height: number;
}
interface PaddingBoxInterface extends BoxInterface {
    border: {
        top: number;
        right: number;
        bottom: number;
        left: number;
    };
}
interface ContentBoxInterface extends PaddingBoxInterface {
    padding: {
        top: number;
        right: number;
        bottom: number;
        left: number;
    };
}
interface ScrollDimensionsInterface {
    width: number;
    height: number;
}
interface ScrollPositionInterface {
    top: number;
    left: number;
}
declare type StylesInterface = Record<string, any>;
declare type BorderBoxKey = "borderBox" | "borderBoxWithScroll" | "borderBoxWithScale" | "borderBoxWithScrollWithScale";
declare type PaddingBoxKey = "paddingBox" | "paddingBoxWithScroll" | "paddingBoxWithScale" | "paddingBoxWithScrollWithScale";
declare type ContentBoxKey = "contentBox" | "contentBoxWithScroll" | "contentBoxWithScale" | "contentBoxWithScrollWithScale";
declare type ScrollDimensionsKey = "scrollDimensions" | "scrollDimensionsWithScale";
declare type ScrollPositionKey = "scrollPosition" | "scrollPositionWithScale" | "scrollPositionWithZoom" | "scrollPositionWithScaleWithZoom";
interface ElementCache {
    computedStyle?: Map<string, CSSStyleDeclaration>;
    computedStyleMap?: StylePropertyMapReadOnly;
    borderBox?: BoxInterface;
    borderBoxWithScroll?: BoxInterface;
    borderBoxWithScale?: BoxInterface;
    borderBoxWithScrollWithScale?: BoxInterface;
    paddingBox?: PaddingBoxInterface;
    paddingBoxWithScroll?: PaddingBoxInterface;
    paddingBoxWithScale?: PaddingBoxInterface;
    paddingBoxWithScrollWithScale?: PaddingBoxInterface;
    contentBox?: ContentBoxInterface;
    contentBoxWithScroll?: ContentBoxInterface;
    contentBoxWithScale?: ContentBoxInterface;
    contentBoxWithScrollWithScale?: ContentBoxInterface;
    scrollDimensions?: ScrollDimensionsInterface;
    scrollDimensionsWithScale?: ScrollDimensionsInterface;
    scrollPosition?: ScrollPositionInterface;
    scrollPositionWithScale?: ScrollPositionInterface;
    scrollPositionWithZoom?: ScrollPositionInterface;
    scrollPositionWithScaleWithZoom?: ScrollPositionInterface;
    scaleXFactor?: number;
    scaleYFactor?: number;
    zoom?: number;
    isRTL?: boolean;
}
interface ScrollInterface {
    top: number;
    left: number;
}
interface GapInterface {
    top: number;
    left: number;
}
declare class DomMeasurement {
    private static IMPORTANT_REG_EXP;
    private static NON_STATIC_POSITIONS;
    private static MIN_TEXT_BOX_WIDTH;
    private _window;
    private _document;
    private _documentVisibleBox;
    private _documentGap;
    private _documentScroll;
    private _elementCache;
    constructor(doc?: HTMLDocument);
    private _getElementCache;
    clearCache(): void;
    private _contains;
    private _getComputedStyle;
    getComputedStyle(element: HTMLElement, pseudoElt?: string): CSSStyleDeclaration;
    private _getComputedStyleMap;
    getComputedStyleMap(element: HTMLElement): StylePropertyMapReadOnly | null;
    getInlineStyle(element: HTMLElement, prop: string): string;
    getStyle(element: HTMLElement, prop: string, pseudoElt?: string): any;
    getStyles(element: HTMLElement, props: string[], pseudoElt?: string): StylesInterface;
    getExactStyle(element: HTMLElement, prop: string): any;
    getExactStyles(element: HTMLElement, props: string[]): StylesInterface;
    setStyles(element: HTMLElement, styles: StylesInterface, _isImportant?: boolean): void;
    copyStyles(fromElement: HTMLElement, toElement: HTMLElement, props: string[], _isImportant?: boolean): void;
    resetStyles(element: HTMLElement, styles: StylesInterface, isImportant?: boolean): void;
    private _getBorderBox;
    getBorderBox(element: HTMLElement, withScroll?: boolean, withScale?: boolean): BoxInterface;
    private _getPaddingBox;
    getPaddingBox(element: HTMLElement, withScroll?: boolean, withScale?: boolean): PaddingBoxInterface;
    private _getContentBox;
    getContentBox(element: HTMLElement, withScroll?: boolean, withScale?: boolean): ContentBoxInterface;
    private _getScrollDimensions;
    getScrollDimensions(element: HTMLElement, withScale?: boolean): ScrollDimensionsInterface;
    private _getScrollPosition;
    getScrollPosition(element: HTMLElement, withScale?: boolean, withZoom?: boolean): ScrollPositionInterface;
    private _getScaleXFactor;
    getScaleXFactor(element: HTMLElement): number;
    private _getScaleYFactor;
    getScaleYFactor(element: HTMLElement): number;
    _getZoom(element: HTMLElement, cache: ElementCache): number;
    getZoom(element: HTMLElement): number;
    private _getStackingContextWithZIndex;
    getZIndex(element: Node, highestAncestor?: HTMLElement): number | "auto";
    private _isRTL;
    isRTL(element: HTMLElement): boolean;
    isStackingContext(element: HTMLElement): boolean;
    getTextBoundingBoxes(textRanges: TextRange | TextRange[], parentElement: HTMLElement, withScroll?: boolean): BoxInterface[];
    /**
     * Return bounding boxes which contains specified text range with coordinates relative to element.
     *
     * @param textRange - Specified text range.
     * @param element - Target element.
     * @param elementScroll - Element scroll positions.
     */
    getRelativeTextBoundingBoxes(textRange: TextRange, element: HTMLElement, elementScroll?: ScrollPositionInterface, flag?: boolean): BoxInterface[];
    /**
     * Return bounding boxes which contains specified text ranges with coordinates relative to element.
     *
     * @param textRanges - Specified text ranges.
     * @param element - Target element.
     * @param elementScroll - Element scroll positions.
     */
    getRelativeTextBoundingBoxes(textRanges: TextRange[], element: HTMLElement, elementScroll?: ScrollPositionInterface, flag?: boolean): BoxInterface[];
    /**
     * For given text ranges calculate bounding rectangle which contains all bounding rectangles with coordinates relative to element coordinates.
     *
     * @param textRanges - text ranges.
     * @param element - element which contains given text ranges.
     */
    getRelativeTextBoundingBox(textRanges: TextRange[], element: HTMLElement): BoxInterface;
    private _hasRelativePosition;
    getDocumentGap(): GapInterface;
    getDocumentVisibleBox(): BoxInterface;
    getDocumentScroll(): ScrollInterface;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
interface MessageLocalizationData {
    description?: string;
    message: string;
    placeholders?: {
        [placeholderName: string]: {
            content: string;
            example?: string;
        };
    };
}
declare const LOCALIZATION_DATA: {
    [languageCode: string]: {
        [messageName: string]: MessageLocalizationData;
    };
};
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
 * Base class for internalization API.
 */
declare abstract class i18nManagerClass {
    /**
     * Names of fired events.
     */
    static readonly eventNames: {
        localeChanged: string;
    };
    /**
     * Subscribe to event with specified name.
     *
     * @param eventType - Event name.
     * @param callback - Event handler.
     */
    abstract addEventListener(eventType: string, callback: (data: any) => void): void;
    /**
     * Set which localization language should be used.
     *
     * @param localeCode - Language code, support language variations (like en_GB).
     */
    abstract setLocale(localeCode: string): void;
    /**
     * Gets the localized string for the specified message. If the message is missing, this method returns an empty
     * string (''). If the format of the `getMessage()` call is wrong — for example, _messageName_ is not a string or
     * the _substitutions_ array has more than 9 elements — this method returns `undefined`.
     * @param messageName The name of the message, as specified in the `messages.json` file.
     * @param [substitutions] Substitution strings, if the message requires any.
     * @returns Message localized for current locale.
     */
    abstract getMessage(messageName: string, substitutions?: string | number | (string | number)[]): string;
}
/**
 * Proxy class for internalization API specified for current environment.
 */
declare const i18nManager: i18nManagerClass & {
    init(instance: i18nManagerClass): void;
};
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
 * Implement internalization API for standalone app environment.
 */
declare class Standalonei18nManager extends i18nManagerClass {
    private static _formatString;
    private static _replacePlaceholders;
    /**
     * Helper for event communication.
     */
    protected readonly _eventBus: EventBus;
    /**
     * Language code used for localization.
     */
    protected _localeCode: string;
    /**
     * Init new instance.
     */
    constructor();
    /**
     * Subscribe to event with specified name.
     *
     * @param eventType - Event name.
     * @param callback - Event handler.
     */
    addEventListener(eventType: string, callback: (data: any) => void): void;
    /**
     * Set which localization language should be used.
     *
     * @param localeCode - Language code, support language variations in form en_GB.
     */
    setLocale(localeCode: string): void;
    /**
     * Gets the localized string for the specified message. If the message is missing, this method returns an empty
     * string (''). If the format of the `getMessage()` call is wrong — for example, _messageName_ is not a string or
     * the _substitutions_ array has more than 9 elements — this method returns `undefined`.
     * @param messageName The name of the message, as specified in the `messages.json` file.
     * @param [substitutions] Substitution strings, if the message requires any.
     * @returns Message localized for current locale.
     */
    getMessage(messageName: string, substitutions?: string | number | (string | number)[]): string;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
 * Contains information about language.
 */
interface LanguageInfo {
    /**
     * Language code, like "en-us".
     */
    code: string;
    /**
     * Language name.
     */
    name: string;
}
/**
 * Contains methods for working with languages.
 */
declare class LanguageManager {
    /**
     * All supported languages.
     */
    static _languages: LanguageInfo[] | null;
    /**
     * Is LanguageManager subscribed on i18nManager.eventNames.localeChanged event.
     */
    private static _isSubscribed;
    /**
     * All supported languages.
     */
    static get LANGUAGES(): LanguageInfo[];
    /**
     * Return true if specified language is variant of any main language.
     *
     * @param language - Language.
     */
    static isLanguageVariant(language: LanguageInfo): boolean;
    /**
     * Return primary language code for passed language code.
     *
     * @param languageCode - Language code.
     */
    static getPrimaryLanguageCode(languageCode: string): string;
    /**
     * Format language code as "en-GB" or "ca-ES-valencia".
     *
     * @param languageCode - Language code.
     */
    static formatLanguageCode(languageCode: string): string;
    /**
     * Return code of user main language.
     */
    static getUserLanguageCode(): string;
    /**
     * Return codes of all acceptable user languages.
     */
    static getUserLanguageCodes(): string[];
    /**
     * Find preferred variant from list of language variants.
     *
     * @param variants - List of language variants.
     */
    static getPreferredLanguageVariant(variants: string[]): string | null;
    /**
     * Asynchronously retrieve possible user language and country.
     */
    static getLanguagesForGeoIPCountry(): Promise<{
        geoIpLanguages: string[];
        geoIpCountry: string;
    }>;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
interface IgnoredRule {
    id: string;
    /**
     * Rule ignored only for specified language, use "*" as wildcard.
     */
    language: string;
    description?: string;
    phrase?: string;
    /**
     * Turn off date, null if rule is ignored by default.
     */
    turnOffDate?: Date | null;
}
interface DisabledEditorGroup {
    domain: string;
    editorGroupId: string;
}
interface Settings {
    apiServerUrl: string;
    autoCheck: boolean;
    havePremiumAccount: boolean;
    knownEmail: string;
    username: string;
    password: string;
    token: string;
    motherTongue: string;
    geoIpLanguages: string[];
    geoIpCountry: string;
    enVariant: string;
    deVariant: string;
    ptVariant: string;
    caVariant: string;
    dictionary: string[];
    isDictionarySynced: boolean;
    hasSynonymsEnabled: boolean;
    ignoredRules: IgnoredRule[];
    disabledDomains: string[];
    disabledDomainsCapitalization: string[];
    disabledEditorGroups: DisabledEditorGroup[];
    ignoreCheckOnDomains: string[];
    autoCheckOnDomains: string[];
}
interface ManagedSettings {
    apiServerUrl: string;
    loginUrl: string;
    disablePrivacyConfirmation: boolean;
    disablePersonalDictionary: boolean;
    disableIgnoredRules: boolean;
}
interface Configuration {
    unsupportedDomains: string[];
}
interface PrivacySettings {
    allowRemoteCheck: boolean;
}
interface Statistics {
    usageCount: number;
    sessionCount: number;
    appliedSuggestions: number;
    appliedSynonyms: number;
    hiddenErrors: {
        day: string;
        count: number;
    }[];
    firstVisit: number | null;
    lastActivity: number | null;
    ratingValue: "like" | "dislike" | null;
    premiumClicks: number;
    isOverleafUser: boolean;
}
interface UIState {
    hasSeenPrivacyConfirmationDialog: boolean;
    hasPaidSubscription: boolean;
    hasRated: boolean;
    hasUsedValidator: boolean;
    hasSeenOnboarding: boolean;
    isNewUser: boolean;
    hasSeenNewGoogleDocsTeaser: boolean;
    hasSeenGoogleDocsMenuBarHint: boolean;
    hasSeenSynonymsTutorial: boolean;
    lastChangelogSeen: number | null;
    changelogCountdownEnd: number | null;
    showRuleId: boolean;
}
interface TestFlags {
}
interface CouponInterface {
    code: string;
    expires: number;
    percent: number;
}
interface StorageDataChanges {
    apiServerUrl?: {
        oldValue?: string;
        newValue: string;
    };
    autoCheck?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    havePremiumAccount?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    knownEmail?: {
        oldValue?: string;
        newValue: string;
    };
    username?: {
        oldValue?: string;
        newValue: string;
    };
    password?: {
        oldValue?: string;
        newValue: string;
    };
    token?: {
        oldValue?: string;
        newValue: string;
    };
    motherTongue?: {
        oldValue?: string;
        newValue: string;
    };
    geoIpLanguages?: {
        oldValue?: string[];
        newValue: string[];
    };
    geoIpCountry?: {
        oldValue?: string;
        newValue: string;
    };
    enVariant?: {
        oldValue?: string;
        newValue: string;
    };
    deVariant?: {
        oldValue?: string;
        newValue: string;
    };
    ptVariant?: {
        oldValue?: string;
        newValue: string;
    };
    caVariant?: {
        oldValue?: string;
        newValue: string;
    };
    dictionary?: {
        oldValue?: string[];
        newValue: string[];
    };
    isDictionarySynced?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    hasSynonymsEnabled?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    ignoredRules?: {
        oldValue?: {
            id: string;
            language: string;
            description: string;
            phrase?: string;
            turnOffDate: number | null;
        }[];
        newValue: {
            id: string;
            language: string;
            description: string;
            phrase?: string;
            turnOffDate: number | null;
        }[];
    };
    disabledDomains?: {
        oldValue?: string[];
        newValue: string[];
    };
    disabledDomainsCapitalization?: {
        oldValue?: string[];
        newValue: string[];
    };
    disabledEditorGroups?: {
        oldValue?: DisabledEditorGroup[];
        newValue: DisabledEditorGroup[];
    };
    ignoreCheckOnDomains?: {
        oldValue?: string[];
        newValue: string[];
    };
    autoCheckOnDomains?: {
        oldValue?: string[];
        newValue: string[];
    };
    unsupportedDomains?: [];
    allowRemoteCheck?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    usageCount?: {
        oldValue?: number;
        newValue: number;
    };
    sessionCount?: {
        oldValue?: number;
        newValue: number;
    };
    appliedSuggestions?: {
        oldValue?: number;
        newValue: number;
    };
    appliedSynonyms?: {
        oldValue?: number;
        newValue: number;
    };
    hiddenErrors?: {
        oldValue?: {
            day: string;
            count: number;
        }[];
        newValue: {
            day: string;
            count: number;
        }[];
    };
    firstVisit?: {
        oldValue?: number | null;
        newValue: number;
    };
    ratingValue?: {
        oldValue?: "like" | "dislike" | null;
        newValue: "like" | "dislike";
    };
    premiumClicks?: {
        oldValue?: number;
        newValue: number;
    };
    isOverleafUser?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    hasSeenPrivacyConfirmationDialog?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    hasPaidSubscription?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    hasRated?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    hasUsedValidator?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    hasSeenOnboarding?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    isNewUser?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    hasSeenNewGoogleDocsTeaser?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    hasSeenNewGoogleDocsMenuBarHint?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    hasSeenSynonymsTutorial?: {
        oldValue?: boolean;
        newValue: boolean;
    };
    lastChangelogSeen?: {
        oldValue?: number | null;
        newValue: number | null;
    };
    changelogCountdownEnd?: {
        oldValue?: number | null;
        newValue: number | null;
    };
}
/**
 * Validation settings.
 */
interface ValidationSettings {
    /**
     * Is validation on entire domain disabled.
     */
    isDomainDisabled: boolean;
    /**
     * Is validation on editor group disabled
     */
    isEditorGroupDisabled: boolean;
    /**
     * Is autovalidation enabled.
     */
    isAutoCheckEnabled: boolean;
    /**
     * Is text capitalization should be validated.
     */
    shouldCapitalizationBeChecked: boolean;
}
/**
 * Data provider.
 */
declare abstract class StorageControllerClass {
    /**
     * Names of fired events.
     */
    static readonly eventNames: {
        settingsChanged: string;
        configurationChanged: string;
        privacySettingsChanged: string;
        uiStateChanged: string;
    };
    /**
     * Default settings values.
     */
    protected static readonly DEFAULT_SETTINGS: Settings;
    static PICKY_RULE_IDS: string[];
    /**
     * Default managed settings values.
     */
    static readonly DEFAULT_MANAGED_SETTINGS: ManagedSettings;
    /**
     * Default configuration values.
     */
    static readonly DEFAULT_CONFIGURATION: Configuration;
    /**
     * Default privacy settings values.
     */
    protected static readonly DEFAULT_PRIVACY_SETTINGS: PrivacySettings;
    /**
     * Default statistics values.
     */
    protected static readonly DEFAULT_STATISTICS: Statistics;
    /**
     * Default UI state values.
     */
    protected static readonly DEFAULT_UI_STATE: UIState;
    /**
     * Default test flags values.
     */
    protected static readonly DEFAULT_TEST_FLAGS: TestFlags;
    /**
     * Create new object with fields same as defaultObject but values will be replaced with values from dataObject.
     *
     * @param defaultObject - Source object which define signature of result object.
     * @param dataObject - Data object from which values are copied.
     */
    protected static _combineObjects<T>(defaultObject: T, dataObject: any): T;
    /**
     * Convert decimal number to hexadecimal.
     *
     * @param value - Number, which should be converted.
     */
    protected static _dec2hex(value: number): string;
    /**
     * Return new unique id (16 chars string).
     */
    protected static _generateUniqueId(): string;
    /**
     * Return normalized domain (in lower case and without "www").
     *
     * @param domain - Domain (subdomain), which should be normalized.
     */
    protected static _normalizeDomain(domain?: string): string;
    /**
     * Find is list contains passed domain or top level domain for passed domain.
     *
     * @param list - List of domains.
     * @param domain - Checked domain.
     */
    protected static _isListContainsDomain(list: string[], domain: string): boolean;
    static getDefaultSettings(): Settings;
    static getDefaultPrivacySettings(): PrivacySettings;
    /**
     * Helper for event communication.
     */
    protected readonly _eventBus: EventBus;
    /**
     * List of callbacks that should be called after initialization.
     */
    protected _onReadyCallbacks: ((storageController: StorageControllerClass) => void)[];
    /**
     * Unique user id.
     */
    protected _uniqueId: string;
    /**
     * Init new instance and invoke callback function after initialization.
     *
     * @param callback - Callback function which will be called after initialization.
     */
    constructor(callback?: (storageController: StorageControllerClass) => void);
    /**
     * Is instance initialized.
     */
    abstract isReady(): boolean;
    /**
     * Invoke callback function after initialization or immediately if instance is already initialized.
     *
     * @param callback - Callback function.
     */
    abstract onReady(callback: (storageController: StorageControllerClass) => void): void;
    /**
     * Subscribe to event with specified name.
     *
     * @param eventType - Event name.
     * @param callback - Event handler.
     */
    addEventListener(eventType: string, callback: (data: any) => void): void;
    /**
     * Return stored unique id.
     */
    abstract getUniqueId(): string;
    /**
     * Return settings. Changing this values doesn't affect stored values.
     */
    abstract getSettings(): Settings;
    /**
     * Update settings.
     *
     * @param settings - New settings values.
     */
    abstract updateSettings(settings: Partial<Settings>): Promise<void>;
    /**
     * Return validation settings for domain.
     *
     * @param domain - Domain for validation settings.
     */
    abstract getValidationSettings(domain: string, editorGroupId: string): ValidationSettings;
    /**
     * Disable validation on domain/subdomain.
     *
     * @param domain - Domain/subdomain on which validation should be disabled.
     */
    disableDomain(domain: string): Promise<void>;
    /**
     * Enable validation on domain/subdomain.
     *
     * @param domain - Domain/subdomain on which validation should be enabled.
     */
    enableDomain(domain: string): Promise<void>;
    /**
     * Disable validation on editor group
     *
     * @param domain - Domain/subdomain on which validation should be disabled.
     * @param editorGroupId - editor group id on which validation should be disabled.
     */
    disableEditorGroup(domain: string, editorGroupId: string): Promise<void>;
    /**
     * Enable validation on editor group
     *
     * @param domain - Domain/subdomain on which validation should be disabled.
     * @param editorGroupId - editor group id on which validation should be disabled.
     */
    enableEditorGroup(domain: string, editorGroupId: string): Promise<void>;
    /**
     * Enable domain and editor group.
     *
     * @param domain - Domain/subdomain on which validation should be enabled.
     * @param editorGroupId - id of editor group on which validation should be enabled.
     */
    enableDomainAndEditorGroup(domain: string, editorGroupId: string): Promise<void>;
    /**
     * Disable validation of text capitalization on domain.
     *
     * @param domain - Domain/subdomain on which validation of text capitalization should be disabled.
     */
    disableCapitalization(domain: string): Promise<void>;
    /**
     * Enable validation of text capitalization on domain.
     *
     * @param domain - Domain/subdomain on which validation of text capitalization should be enabled.
     */
    enableCapitalization(domain: string): Promise<void>;
    /**
     * Is custom validation server used.
     */
    abstract isUsedCustomServer(): boolean;
    /**
     * Return url of custom validation server setted by user.
     */
    abstract getCustomServerUrl(): string | null;
    /**
     * Return maximum length of text available for validation.
     */
    getMaxTextLength(): number;
    /**
     * Return managed settings. Changing this values doesn't affect stored values.
     */
    abstract getManagedSettings(): ManagedSettings;
    /**
     * Return configuration. Changing this values doesn't affect stored values.
     */
    abstract getConfiguration(): Configuration;
    /**
     * Update configuration.
     *
     * @param configuration - New configuration values.
     */
    abstract updateConfiguration(configuration: Partial<Configuration>): Promise<void>;
    /**
     * Check is specified domain supported.
     *
     * @param domain - Domain.
     */
    abstract isDomainSupported(domain: string): boolean;
    /**
     * Return privacy settings. Changing this values doesn't affect stored values.
     */
    abstract getPrivacySettings(): PrivacySettings;
    /**
     * Update privacy settings.
     *
     * @param privacySettings - New privacy settings values.
     */
    abstract updatePrivacySettings(privacySettings: Partial<PrivacySettings>): Promise<void>;
    /**
     * Return statistics. Changing this values doesn't affect stored values.
     */
    abstract getStatistics(): Statistics;
    /**
     * Update statistics.
     *
     * @param statistics - New statistics values.
     */
    abstract updateStatistics(statistics: Partial<Statistics>): Promise<void>;
    /**
     * Return UI state. Changing this values doesn't affect stored values.
     */
    abstract getUIState(): UIState;
    /**
     * Update UI state.
     *
     * @param uiState - New UI state values.
     */
    abstract updateUIState(uiState: Partial<UIState>): Promise<void>;
    /**
     * Check is user has paid subscription.
     */
    abstract checkForPaidSubscription(): Promise<boolean>;
    /**
     * Enable paid subscription.
     */
    abstract enablePaidSubscription(): Promise<void>;
    /**
     * Disable paid subscription.
     */
    abstract disablePaidSubscription(): Promise<void>;
    /**
     * Return test flags. Changing this values doesn't affect stored values.
     */
    abstract getTestFlags(): TestFlags;
    /**
     * Update test flags.
     *
     * @param testFlags - New test flags values.
     */
    abstract updateTestFlags(testFlags: Partial<TestFlags>): Promise<void>;
    /**
     * Return information for currently active coupon.
     */
    abstract getActiveCoupon(): CouponInterface | null;
    /**
     * Should changelog be displayed to user.
     */
    abstract isReleventForChangelogCoupon(): {
        status: boolean;
        reason?: number;
    };
    /**
     * Start countdown for changelog coupon.
     */
    abstract startChangelogCoupon(): void;
    /**
     * Unsubscribe all event handlers and free all resources.
     */
    destroy(): void;
}
declare abstract class StorageController {
    private static _instanceFactory;
    static init(instanceFactory: (callback?: (storageController: StorageControllerClass) => void) => StorageControllerClass): void;
    static create(): StorageControllerClass;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
 * Data provider for standalone app.
 */
declare class StandaloneStorageController extends StorageControllerClass {
    /**
     * Names of settings which should be stored at local storage.
     */
    private static STORED_SETTINGS;
    /**
     * Cached settings values.
     */
    private _settings;
    /**
     * Predefined privacy settings values.
     */
    private _privacySettings;
    /**
     * Predefined UI state values.
     */
    private _uiState;
    /**
     * Init new instance and invoke callback function after initialization.
     *
     * @param callback - Callback function which will be called after initialization.
     */
    constructor();
    /**
     * Load and cache stored data.
     */
    private _loadData;
    /**
     * Is instance initialized.
     */
    isReady(): boolean;
    /**
     * Invoke callback function after initialization or immediately if instance is already initialized.
     *
     * @param callback - Callback function.
     */
    onReady(callback: (storageController: StorageControllerClass) => void): void;
    /**
     * Return stored unique id.
     */
    getUniqueId(): string;
    /**
     * Return settings. Changing this values doesn't affect stored values.
     */
    getSettings(): Settings;
    /**
     * Update settings.
     *
     * @param settings - New settings values.
     */
    updateSettings(settings: Partial<Settings>): Promise<void>;
    /**
     * Return validation settings for domain.
     *
     * @param domain - Domain for validation settings.
     */
    getValidationSettings(domain: string): ValidationSettings;
    /**
     * Is custom validation server used.
     */
    isUsedCustomServer(): boolean;
    /**
     * Return url of custom validation server setted by user.
     */
    getCustomServerUrl(): string | null;
    /**
     * Return managed settings. Changing this values doesn't affect stored values.
     */
    getManagedSettings(): ManagedSettings;
    /**
     * Return configuration. Changing this values doesn't affect stored values.
     */
    getConfiguration(): Configuration;
    /**
     * Update configuration.
     *
     * @param configuration - New configuration values.
     */
    updateConfiguration(configuration: Partial<Configuration>): Promise<void>;
    /**
     * Check is specified domain supported.
     *
     * @param domain - Domain.
     */
    isDomainSupported(domain: string): boolean;
    /**
     * Return privacy settings. Changing this values doesn't affect stored values.
     */
    getPrivacySettings(): PrivacySettings;
    /**
     * Update privacy settings.
     *
     * @param privacySettings - New privacy settings values.
     */
    updatePrivacySettings(privacySettings: Partial<PrivacySettings>): Promise<void>;
    /**
     * Return statistics. Changing this values doesn't affect stored values.
     */
    getStatistics(): Statistics;
    /**
     * Update statistics.
     *
     * @param statistics - New statistics values.
     */
    updateStatistics(statistics: Partial<Statistics>): Promise<void>;
    /**
     * Return UI state. Changing this values doesn't affect stored values.
     */
    getUIState(): UIState;
    /**
     * Update UI state.
     *
     * @param uiState - New UI state values.
     */
    updateUIState(uiState: Partial<UIState>): Promise<void>;
    /**
     * Check is user has paid subscription.
     */
    checkForPaidSubscription(): Promise<boolean>;
    /**
     * Enable paid subscription.
     */
    enablePaidSubscription(): Promise<void>;
    /**
     * Disable paid subscription.
     */
    disablePaidSubscription(): Promise<void>;
    /**
     * Return test flags. Changing this values doesn't affect stored values.
     */
    getTestFlags(): TestFlags;
    /**
     * Update test flags.
     *
     * @param testFlags - New test flags values.
     */
    updateTestFlags(testFlags: Partial<TestFlags>): Promise<void>;
    /**
     * Return information for currently active coupon.
     */
    getActiveCoupon(): CouponInterface | null;
    /**
     * Should changelog be displayed to user.
     */
    isReleventForChangelogCoupon(): {
        status: boolean;
        reason?: number;
    };
    /**
     * Start countdown for changelog coupon.
     */
    startChangelogCoupon(): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
interface ValidateResult {
    isSuccessful: true;
    instanceId: string;
    text: string;
    changedParagraphs: Paragraph[];
    language: LanguageInfo | null;
    isUnsupportedLanguage: boolean;
    isIncompleteResult: boolean;
    validationErrors: TextError[];
    validationPremiumErrors: TextError[];
    validationPickyErrors: TextError[];
    partialValidationErrors: TextError[];
    partialValidationPremiumErrors: TextError[];
    partialValidationPickyErrors: TextError[];
}
interface ValidateError {
    isSuccessful: false;
    instanceId: string;
    error: ValidationError;
}
declare type ExtensionType = "extension" | "standalone";
declare abstract class EnvironmentAdapterClass {
    abstract isProductionEnvironment(): boolean;
    abstract isRuntimeConnected(): boolean;
    abstract getVersion(): string;
    abstract getTrackingId(): string;
    abstract getType(): ExtensionType;
    abstract getURL(path: string): string;
    abstract getUILanguageCode(): string;
    abstract loadContentScripts(win: Window, type: "js" | "css"): void;
    abstract getPreferredLanguages(): Promise<string[]>;
    abstract startDictionarySync(): Promise<void>;
    abstract updateDictionary(): Promise<void>;
    abstract addWordToDictionary(word: string): Promise<void>;
    abstract addWordsToDictionary(words: string[]): Promise<void>;
    abstract removeWordFromDictionary(word: string): Promise<void>;
    abstract clearDictionary(): Promise<void>;
    abstract loadSynonyms(wordContext: WordContextInfo, language: string, motherTongue: string): Promise<SynonymResult>;
    abstract trackEvent(action: string, label: string | null): Promise<void>;
    abstract trackTextLength(textLength: number): Promise<void>;
    abstract pageLoaded(enabled: boolean, capitalization: boolean, supported: boolean, beta: boolean, unsupportedMessage: string): Promise<void>;
    abstract ltAssistantStatusChanged(status: {
        enabled?: boolean;
        capitalization?: boolean;
    }): Promise<void>;
    abstract ltAssistantStatusChanged(tabId: number, status: {
        enabled?: boolean;
        capitalization?: boolean;
    }): Promise<void>;
    abstract validate(editor: SpellcheckEditor, text: string, changedParagraphs: Paragraph[], hasUserChangedLanguage: boolean, url: string, recipientInfo: RecipientInfo): Promise<ValidateResult | ValidateError | void>;
    abstract isOptionsPageSupported(): boolean;
    abstract openOptionsPage(target?: string, ref?: string): Promise<void>;
    abstract isFeedbackFormSupported(): boolean;
    abstract openFeedbackForm(url: string, title?: string, html?: string): Promise<void>;
}
declare const EnvironmentAdapter: EnvironmentAdapterClass & {
    init(instance: EnvironmentAdapterClass): void;
};
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
declare class StandaloneEnvironmentAdapter extends EnvironmentAdapterClass {
    private static readonly UNSUPPORTED_LANGUAGE_NAME;
    private _storageController;
    private _widgetBaseURL;
    constructor();
    isProductionEnvironment(): boolean;
    isRuntimeConnected(): boolean;
    getVersion(): string;
    getTrackingId(): string;
    getType(): ExtensionType;
    getURL(path: string): string;
    getUILanguageCode(): string;
    loadContentScripts(win: Window, type: "js" | "css"): void;
    getPreferredLanguages(withoutVariants?: boolean): Promise<string[]>;
    startDictionarySync(): Promise<void>;
    updateDictionary(): Promise<void>;
    addWordToDictionary(word: string): Promise<void>;
    addWordsToDictionary(words: string[]): Promise<void>;
    removeWordFromDictionary(word: string): Promise<void>;
    clearDictionary(): Promise<void>;
    loadSynonyms(wordContext: WordContextInfo, language: string, motherTongue: string): Promise<SynonymResult>;
    trackEvent(action: string, label: string | null): Promise<void>;
    trackTextLength(textLength: number): Promise<void>;
    pageLoaded(enabled: boolean, capitalization: boolean, supported: boolean, beta: boolean, unsupportedMessage: string): Promise<void>;
    ltAssistantStatusChanged(status: {
        enabled?: boolean | undefined;
        capitalization?: boolean | undefined;
    }): Promise<void>;
    ltAssistantStatusChanged(tabId: number, status: {
        enabled?: boolean | undefined;
        capitalization?: boolean | undefined;
    }): Promise<void>;
    validate(editor: SpellcheckEditor, text: string, changedParagraphs: Paragraph[], hasUserChangedLanguage: boolean, url: string, recipientInfo: RecipientInfo): Promise<ValidateResult | ValidateError | void>;
    isOptionsPageSupported(): boolean;
    openOptionsPage(target?: string | undefined, ref?: string | undefined): Promise<void>;
    isFeedbackFormSupported(): boolean;
    openFeedbackForm(url: string, title?: string | undefined, html?: string | undefined): Promise<void>;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
declare type ErrorCategory = "JS-Error" | "HTTP-Error" | "Message-Error" | "Other-Error";
declare type ActionCategory = "Action" | "Debug" | "Stat" | "AppliedRule" | "AddToDictionary" | "OpenErrorCard" | "TempIgnoreWord" | ErrorCategory;
declare class Tracker {
    /**
     * Piwik endpoint url.
     */
    private static readonly TRACKING_BASE_URL;
    /**
     * Fake URL for piwik.
     */
    private static readonly TRACKING_BASE_PAGE_URL;
    /**
     * Extension id.
     */
    private static readonly TRACKING_SITE_ID;
    /**
     * Track activity not more often than 24 hours.
     */
    private static readonly ACTIVITY_TRACK_INTERVAL;
    /**
     * Throttle error tracking.
     */
    private static readonly MAX_TIME;
    private static readonly THROTTLE_REQUESTS;
    private static readonly VERSION;
    private static readonly _storageController;
    private static _isInitialized;
    /**
     * Tracked errors timestamps.
     */
    private static _loggedErrors;
    /**
     * Count of tracked errors.
     */
    private static _errorCount;
    static _constructor(): void;
    private static _getCustomVariables;
    private static _getTrackingUrlForPageView;
    private static _getTrackingUrlForEvent;
    private static _sendRequest;
    static trackPageView(pageUrl?: string): void;
    static trackDisabledRule(language: string, ruleId: string, contextPhrase: string, isPremium: boolean): void;
    static trackDictionaryEvent(language: string, word: string, isTempIgnored?: boolean): void;
    static trackEvent(actionCategory: ActionCategory, action: string, actionName?: string | null, pageUrl?: string): void;
    static trackInstall(): void;
    static trackActivity(): void;
    static trackError(type: string, errorMessage: string, fileName?: string): void;
    static trackStat(name: string, value: string): void;
    static trackTextLength(textLength: number): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
declare class Dictionary {
    private static _storageController;
    private static _defaultWords;
    private static _isInitialized;
    private static _update;
    static init(storageController?: StorageControllerClass, defaultWords?: string[]): void;
    static get(): string[];
    static getSorted(): string[];
    static add(word: string): Promise<void>;
    static addBatch(words: string[]): Promise<void>;
    static remove(word: string): Promise<void>;
    static clear(): Promise<void>;
}
declare type GoogleDocsMode = "edit" | "suggest" | "view";
declare type GoogleDocsOnPageOutOfViewCallback = ((element: InputArea) => void);
declare type GoogleDocsOnPageInViewCallback = ((element: InputArea) => void);
declare type GoogleDocsOnModeChangeCallback = ((mode: GoogleDocsMode) => void);
declare class GoogleDocs {
    static DOCS_URL_REGEXP: RegExp;
    static MOUSE_EVENT_DETAIL: number;
    private static BULLET_POINT_REGEXP;
    private static ZWNJ_END_REGEXP;
    private static URL_FRAGMENT_REG_EXP;
    private static FILE_NAME_REGEXP;
    private static DOC_ID_REG_EXP;
    private static WHITE_SPACE_REGEXP;
    static TOOLBAR_CLASS_NAME: string;
    private static PAGE_CLASS_NAME;
    private static LINE_CLASS_NAME;
    private static TEXT_BLOCK_CLASS_NAME;
    private static UNHANDLED_PAGE_SELECTOR;
    private static STRIKETHROUGH_SELECTOR;
    private static _interval;
    private static _currentMode;
    private static _onModeChangeCallbacks;
    private static _onPageOutOfViewCallbacks;
    private static _onPageInViewCallbacks;
    private static _domMeasurement;
    private static _pages;
    private static _kixContainer;
    private static _storageController;
    private static _menuBarButton;
    private static _menuBarSeparator;
    private static _menuBarHint;
    private static DISABLED_RULES;
    static init(): void;
    private static _checkForNewPage;
    private static _checkMode;
    private static _checkOutOfViewPages;
    private static _toggleMenubarButton;
    private static _insertMenubarButton;
    private static _removeMenubarButton;
    private static _selectMenubarButton;
    private static _unselectMenubarButton;
    private static _showMenuBarHint;
    static initPage(element: InputArea): {
        destroy: () => void;
    };
    static getDocId(url: string): string | null;
    static onPage(callback: (element: InputArea, checkFocus: boolean) => void): void;
    static isElementCompatible(element: HTMLElement): boolean;
    static getHighlighterZIndex(inputArea: InputArea): number;
    static getToolbarZIndex(inputArea: InputArea): number;
    static getToolbarPosition(inputArea: InputArea, domMeasurement: DomMeasurement): {
        top: string;
        left: string;
        fixed: boolean;
    } | null;
    static isPage(inputArea: Element): boolean;
    static getPreviousPage(inputArea: InputArea): InputArea | null;
    static getNextPage(inputArea: InputArea): InputArea | null;
    static isIgnoredElement(element: HTMLElement): boolean;
    static isBlockElement(element: HTMLElement, computedStyles: CSSStyleDeclaration): boolean;
    /**
     * All whitespaces except zero width spaces
     */
    private static readonly WHITESPACES;
    private static readonly WHITESPACES_REGEXP;
    private static _normalizeWhiteSpace;
    static replaceText(str: string, textNode: TextNode, element: HTMLElement): string;
    private static _replaceText;
    private static _isMainGoogleDocsFrame;
    private static _getMode;
    private static _updateTextBoxes;
    private static _getIframeWin;
    static applyFix(options: ApplyFixOptions): Promise<void>;
    private static _onModeChange;
    private static _isInView;
    private static _onOutOfView;
    static _showTeaser(): void;
    private static _onInput;
    static getSelection(): {
        startNode: Node;
        startOffset: number;
        endNode: Node;
        endOffset: number;
        isCollapsed: boolean;
    } | null;
    static getSelectedText(): string;
    static filterErrors(element: InputArea, errors: TextError[]): TextError[];
    static onPageDestroy(element: InputArea, callback: (element: InputArea) => void): void;
    static destroyPage(element: InputArea): void;
    static destroy(): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
declare type LatexTokenType = "comment" | "switch" | "symbol" | "command";
interface LatexToken {
    type: LatexTokenType;
    start: number;
    end: number;
}
interface LatexCommentToken extends LatexToken {
    type: "comment";
}
interface LatexSwitchToken extends LatexToken {
    type: "switch";
    switchName: string;
    textStart: number;
    textEnd: number;
}
interface LatexSymbolToken extends LatexToken {
    type: "symbol";
    symbolName: string;
}
interface LatexArgument {
    start: number;
    end: number;
}
interface LatexCommandToken extends LatexToken {
    type: "command";
    commandName: string;
    arguments: LatexArgument[];
    optionalArguments: LatexArgument[];
}
declare class LatexParser {
    private static COMMAND_TOKEN_START_REGEXP;
    private static SWITCH_TOKEN_START_REGEXP;
    private static COMMENT_TOKEN_REGEXP;
    private static SYMBOL_NAMES_REGEXP;
    private static _getLatexCommandArgument;
    static getCommandTokens(text: string): LatexCommandToken[];
    static getSwitchTokens(text: string): LatexSwitchToken[];
    static getCommentTokens(text: string): LatexCommentToken[];
    static getSymbolTokens(text: string): LatexSymbolToken[];
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
declare type OverleafOnInputAreaAvailableCallback = ((inputArea: InputArea) => void);
declare class Overleaf {
    private static _interval;
    private static _onInputAreaAvailableCallbacks;
    private static _checkForAvailableInputAreas;
    static init(): void;
    static onInputAreaAvailable(callback: InitElementCallback): void;
    static disableBuiltInValidator(): void;
    static isEditor(element: HTMLElement): boolean;
    static isElementIgnored(inputArea: InputArea, element: HTMLElement): boolean;
    static isBlockElementRelevant(inputArea: InputArea, blockElement: HTMLElement): boolean;
    static getExcludedParts(inputArea: InputArea, text: string): ReplacedPart[];
    static filterErrors(editor: SpellcheckEditor, validatedText: string, errors: TextError[]): TextError[];
    static getToolbarPosition(inputArea: InputArea, isRTL: boolean, toolbarPosition: ToolbarPosition | null): ToolbarPosition | null;
    static applyFix(options: ApplyFixOptions): Promise<void>;
    static destroy(): void;
}
declare class OverleafSourceEditor {
    private static EDITOR_SELECTOR;
    private static HIGHLIGHTED_ERRORS_SELECTOR;
    private static TEXT_LAYER_SELECTOR;
    private static VERTICAL_SCROLLBAR_SELECTOR;
    private static EVENT_TARGET_SELECTOR;
    private static PASTE_TEXTAREA_SELECTOR;
    private static REPLACED_SYMBOLS;
    private static REPLACED_COMMANDS;
    private static COMMANDS_WITH_VALUABLE_ARGUMENT;
    private static _domMeasurement;
    private static _styleTag;
    static _constructor(): void;
    private static _isMouseOnError;
    private static _onEditorMouseDown;
    private static _onEditorContextMenu;
    static disableBuiltInValidator(): void;
    static enableBuiltInValidator(): void;
    static isEditor(element: HTMLElement): boolean;
    static isBlockElementRelevant(blockElement: HTMLElement): boolean;
    static getExcludedParts(text: string): ReplacedPart[];
    static getInputAreas(): InputArea[];
    static isElementIgnored(element: HTMLElement): boolean;
    static filterErrors(validatedText: string, errors: TextError[]): TextError[];
    static getToolbarPosition(inputArea: InputArea, isRTL: boolean, toolbarPosition: ToolbarPosition | null): ToolbarPosition | null;
    static applyFix(options: ApplyFixOptions): Promise<void>;
}
declare class OverleafRichTextEditor {
    private static EDITOR_SELECTOR;
    private static HIGHLIGHTED_ERRORS_SELECTOR;
    private static TEXT_LAYER_SELECTOR;
    private static LINENUMBER_ELEMENT_SELECTOR;
    private static WIDGET_ELEMENT_SELECTOR;
    private static VERTICAL_SCROLLBAR_SELECTOR;
    private static PASTE_TEXTAREA_SELECTOR;
    private static _domMeasurement;
    private static _styleTag;
    static _constructor(): void;
    private static _isMouseOnError;
    private static _onEditorMouseDown;
    private static _onEditorContextMenu;
    static disableBuiltInValidator(): void;
    static enableBuiltInValidator(): void;
    static isEditor(element: HTMLElement): boolean;
    static getInputAreas(): InputArea[];
    static isElementIgnored(element: HTMLElement): boolean;
    static parseText(text: string): string;
    static filterErrors(validatedText: string, errors: TextError[]): TextError[];
    static getToolbarPosition(inputArea: InputArea, isRTL: boolean, toolbarPosition: ToolbarPosition | null): ToolbarPosition | null;
    static applyFix(options: ApplyFixOptions): Promise<void>;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
interface TextIgnoringRule {
    pattern: RegExp;
    preserveNewlineChars: boolean;
    excludedParts?: (boolean | RegExp)[];
}
interface ReplacedPart {
    offset: number;
    length: number;
    replacingText?: string;
}
interface ApplyFixOptions {
    offset: number;
    length: number;
    replacementText: string;
    editor: SpellcheckEditor;
}
interface InputAreaTweaks {
    destroy(): void;
}
declare type InitElementCallback = (element: HTMLElement, checkFocus: boolean) => void;
interface Tweaks {
    init: () => void;
    supported: () => boolean;
    beta: () => boolean;
    unsupportedMessage: () => string;
    getEditorGroupId: (url: string) => string;
    storeTemporaryIgnoredItems: () => boolean;
    onElement: (callback: InitElementCallback) => void;
    isElementCompatible: (element: HTMLElement) => boolean;
    initElement: (inputArea: InputArea) => InputAreaTweaks;
    getClickEvent: () => string;
    getSelectedText: () => string;
    getSelection: () => {
        startNode: Node | null;
        startOffset: number;
        endNode: Node | null;
        endOffset: number;
        isCollapsed: boolean;
    } | null;
    getParsingDetector: (inputArea: InputArea) => ParsingDetector;
    getExcludedParts: (inputArea: InputArea, text: string) => ReplacedPart[];
    filterErrors: (editor: SpellcheckEditor, validatedText: string, errors: TextError[]) => TextError[];
    getRecipientInfo: (inputArea: InputArea) => Promise<RecipientInfo>;
    getHighlighterAppearance: (inputArea: InputArea) => HighlighterAppearance;
    getToolbarAppearance: (inputArea: InputArea) => ToolbarAppearance;
    applyFix: (options: ApplyFixOptions) => Promise<void>;
    isClickIgnored: (e: MouseEvent) => boolean;
    destroy: () => void;
    onElementDestroy: (element: InputArea, callback: (element: any) => void) => void;
}
interface SiteTweaks extends Partial<Tweaks> {
    match: {
        hostname: string | RegExp | (string | RegExp)[];
    } | {
        url: string | RegExp | (string | RegExp)[];
    };
}
declare class TweaksManager {
    /**
     * Tags which is not compatible for validation.
     */
    private static readonly NON_COMPATIBLE_TAGS;
    private static readonly SIGNATURE_ACTIVE_ATTRIBUTE;
    private static readonly SIGNATURE_ATTRIBUTE;
    private static readonly TEXT_IGNORING_DEFAULT_RULES;
    private static readonly EMAIL_REGEXP;
    private static readonly EMAIL_DOMAIN_REGEXP;
    private static readonly ADDRESS_SPECIAL_CHARS_REGEXP;
    private static _isElementCompatibleForGoogleServices;
    private static _splitExcludedPart;
    private static _getExcludedParts;
    private static _getEmail;
    private static _getFullName;
    private static readonly DEFAULT_TWEAKS;
    private static readonly SITE_TWEAKS;
    static getDefaultTweaks(): Tweaks;
    static getTweaks(url: string): Tweaks;
}
declare module "background/graphemeSplitter" {
    export = GraphemeSplitter;
    function GraphemeSplitter(): any;
    class GraphemeSplitter {
        nextBreak: (string: any, index: any) => any;
        splitGraphemes: (str: any) => any[];
        iterateGraphemes: (str: any) => {
            next: any;
        };
        countGraphemes: (str: any) => number;
    }
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
 * Information about recipient of email or chat message.
 */
interface RecipientInfo {
    /**
     * Recipient email address (if available).
     */
    address: string;
    /**
     * Recipient full name.
     */
    fullName: string;
}
/**
 * Additional data for validation request.
 */
interface ValidationMetaData {
    /**
     * Unique (on browser level) id.
     */
    instanceId: string;
    /**
     * Current page url.
     */
    url: string;
    /**
     * Information about recipient of email or chat message.
     */
    recipientInfo: RecipientInfo;
    /**
     * Which profile to use
     */
    checkLevel: CheckLevelType;
}
/**
 * Represent separate paragraph in text.
 */
interface Paragraph {
    /**
     * Paragraph text.
     */
    text: string;
    /**
     * Paragraph start position in text.
     */
    offset: number;
}
/**
 * Error which can be thrown during validation process.
 */
interface ValidationError {
    /**
     * Reason of exception, in case when reason isn't provided check status property.
     */
    reason?: "AbortError" | "ConnectionError" | "TimeoutError";
    /**
     * Response status, can be 0 if response from validation server is not received.
     */
    status: number;
    /**
     * Localized message which is describe exception for user.
     */
    message: string;
    /**
     * Original exception message.
     */
    response: string;
    /**
     * JS Stack trace.
     */
    stack?: string;
}
/**
 * Validation rule used by validation server and extension.
 */
interface ValidationRule {
    /**
     * Unique id.
     */
    id: string;
    /**
     * Rule category.
     */
    category: {
        id: string;
        name: string;
    };
    /**
     * Rule issue type.
     */
    issueType: string;
    /**
     * URLs of pages which contains detailed info about this rule.
     */
    urls?: {
        value: string;
    }[];
    /**
     * Rule description.
     */
    description: string;
    /**
     * Whether it's a rule only available to premium users.
     */
    isPremium: boolean;
    /**
     * The check level this rule was assigned to (e.g. "picky")
     */
    tags?: string[];
    /**
     * Which subrule id
     */
    subId?: string;
}
/**
 * Validation match (error) returned by validation server.
 */
interface ValidationMatch {
    /**
     * Rule associated with match.
     */
    rule: ValidationRule;
    /**
     * Count of words after match text to be sure it's a valid match, -1 mean that sentence needs to be finished.
     */
    contextForSureMatch: number;
    /**
     * Match description.
     */
    message: string;
    /**
     * Brief match description.
     */
    shortMessage: string;
    /**
     * Start position (in validated text) of text which contains match.
     */
    offset: number;
    /**
     * Length of text which contains match.
     */
    length: number;
    /**
     * Possible match replacements.
     */
    replacements: {
        /**
         * Correct version of text with error.
         */
        value: string;
        /**
         * Explanatory text displayed before correct text.
         */
        prefix?: string;
        /**
         * Explanatory text displayed after correct text.
         */
        suffix?: string;
        /**
         * Brief replacement description.
         */
        shortDescription?: string;
        /**
         * Type
         */
        type?: "Translation";
    }[];
}
/**
 * Response from validation server.
 */
interface ValidationResponse {
    /**
     * Text language.
     */
    language: LanguageInfo;
    /**
     * Mathes found in text by validation server.
     */
    matches: ValidationMatch[];
    /**
     * Premium-only matches found in text by validation server.
     */
    hiddenMatches?: ValidationMatch[];
    /**
     * Validation warnings.
     */
    warnings?: {
        /**
         * Because of the large number of matches in text response contains only a part of them.
         */
        incompleteResults: boolean;
    };
}
/**
 * Validation error, used by extension.
 */
interface TextError {
    /**
     * Unique id.
     */
    id?: string;
    /**
     * Is error found by partial validation.
     */
    isPartialValidation: boolean;
    /**
     * Rule associated with error.
     */
    rule: ValidationRule;
    /**
     * Is picky error
     */
    isPicky: boolean;
    /**
     * Is spelling error.
     */
    isSpellingError: boolean;
    /**
     * Is style error.
     */
    isStyleError: boolean;
    /**
     * Is punctuation error.
     */
    isPunctuationError: boolean;
    /**
     * Count of words after error text to be sure it's a valid error, -1 mean that sentence needs to be finished.
     */
    contextForSureMatch: number;
    /**
     * Text language.
     */
    language: LanguageInfo;
    /**
     * Error description.
     */
    description: string;
    /**
     * Brief error description.
     */
    shortDescription: string;
    /**
     * Start position of text which contains error.
     */
    offset: number;
    /**
     * Length of text which contains error.
     */
    length: number;
    /**
     * Error text.
     */
    originalPhrase: string;
    /**
     * Includes original phrase and the characters before and after.
     */
    contextPhrase: string;
    /**
     * Possible error fixes.
     */
    fixes: {
        /**
         * Correct version of text with error.
         */
        value: string;
        /**
         * Explanatory text displayed to the user.
         */
        prefix?: string;
        /**
         * Explanatory text displayed to the user.
         */
        suffix?: string;
        /**
         * Brief fix description.
         */
        shortDescription?: string;
        /**
         * 	Type
         */
        type?: "Translation";
    }[];
}
/**
 * Result of text validation.
 */
interface ValidationResult {
    /**
     * Text language.
     */
    language: LanguageInfo | null;
    /**
     * Errors found in text.
     */
    errors: TextError[];
    /**
     * Premium-only errors found in text (needed to show how many errors the premium version would find)
     */
    premiumErrors: TextError[];
    /**
     * Picky errors found in text
     */
    pickyErrors: TextError[];
}
/**
 * Result of text partial validation.
 */
interface PartialValidationResult {
    /**
     * Text language.
     */
    language: LanguageInfo | null;
    /**
     * Errors found in text.
     */
    errors: TextError[];
    /**
     * Premium-only errors found in text.
     */
    premiumErrors: TextError[];
    /**
     * Premium-only errors found in text.
     */
    pickyErrors: TextError[];
    /**
     * Because of the large number of errors in text result contains only a part of them.
     */
    isIncompleteResult: boolean;
}
/**
 * Validate text by sending requests to validation server.
 */
declare class Validator {
    /**
     * French premium rules (with their popularity rank behind).
     */
    private static readonly FR_PREMIUM_RULES;
    /**
     * Dutch premium rules (with their popularity rank behind).
     */
    private static readonly NL_PREMIUM_RULES;
    /**
     * Polish premium rules (with their popularity rank behind).
     */
    private static readonly PL_PREMIUM_RULES;
    /**
     * Rules for spelling error.
     */
    private static readonly SPELLING_RULES_ID;
    /**
     * Issue types of style error.
     */
    private static readonly STYLE_ISSUE_TYPES;
    /**
     * Common signature separator used in emails.
     */
    private static readonly EMAIL_SIGNATURE_SEPARATOR_REGEXP;
    private static readonly ONLY_NUMBERS_REGEXP;
    private static readonly COLON_WHITESPACE_REGEXP;
    private static readonly ONE_LETTER_AT_END_REGEXP;
    private static readonly NUMBER_WITH_DOT_AT_END_REGEXP;
    private static readonly NUMBER_WITH_PARENTHESIS_AT_END_REGEXP;
    /**
     * Symbols used as marks for unordered lists.
     */
    private static readonly BULLET_POINT_REGEXP;
    private static readonly LOWERCASE_REGEXP;
    private static readonly DOT_WITH_PREFIX_REGEXP;
    private static readonly SLASH_AT_END_REGEXP;
    private static readonly AT_LEAST_TWO_LETTERS_AT_END_REGEXP;
    private static readonly SLASH_AT_BEGINNING_REGEXP;
    private static readonly QUOTE_AT_END_REGEXP;
    private static readonly QUOTE_AT_BEGINNING_REGEXP;
    private static readonly PUNCTUATION_AT_BEGINNING_REGEXP;
    private static readonly PUNCTUATION_SPACE_AT_END_REGEXP;
    private static readonly MARKDOWN_HEADLINE_REGEXP;
    private static readonly MARKDOWN_INLINE_FORMAT_AT_BEGINNING_REGEXP;
    private static readonly PIPE_AT_END_REGEXP;
    private static readonly MENTION_SYMBOL_AT_BEGINNING_REGEXP;
    private static readonly HASH_SYMBOL_AT_BEGINNING_REGEXP;
    private static readonly EMOJI_SENTENCE_START_REGEXP;
    private static readonly ABBREVIATION_AT_END_REGEXP;
    private static readonly NET_AT_BEGINNING_REGEXP;
    private static readonly SINGLE_UPPERCASE_LETTER_REGEXP;
    private static readonly HTML_ENTITIES;
    private static readonly HTML_ENTITIES_WITH_AND;
    private static readonly WAVY_DASH_REGEXP;
    private static readonly ZWS_REGEXP;
    private static readonly ZWNJ_REGEXP;
    private static readonly ZWS;
    /**
     * List of common top-level domains.
     */
    private static readonly COMMON_TLDS;
    /**
     * List of regexps for common top-level domains.
     */
    private static readonly COMMON_TLD_WITH_DOT_REGEXPS;
    /**
     * List of common file extensions.
     */
    private static readonly COMMON_FILE_TYPES;
    /**
     * List of regexps for common file extension with name (some_file.jpg).
     */
    private static readonly COMMON_FILE_TYPE_WITH_DOT_REGEXPS;
    private static readonly FILE_TYPE_AT_BEGINNING_REGEXP;
    /**
     * Data provider for extension storage.
     */
    private static readonly _storageController;
    /**
     * Set of AbortController-s for validation requests mapped by instanceId.
     */
    private static readonly _validationAbortControllers;
    /**
     * Set of AbortController-s for partial validation requests mapped by instanceId.
     */
    private static readonly _partialValidationAbortControllers;
    /**
     * Should fallback server be used for validation requests.
     */
    private static _useValidationFallbackServer;
    /**
     * Should fallback server be used for partial validation requests.
     */
    private static _usePartialValidationFallbackServer;
    /**
     * Time stamp of last failed request to validation server.
     */
    private static _mainServerUnavailabilityTimeStamp;
    /**
     * Is Validator initialized.
     */
    private static _isInitialized;
    /**
     * Init Validator. There is no need to use it in external code.
     */
    static _constructor(): void;
    /**
     * Return validation server url.
     *
     * @param isPartialValidation - Is this for partial validation request, default is false.
     * @param canUseFallbackServer - Can fallback server be used, default is true.
     */
    static getServerBaseUrl(isPartialValidation?: boolean, canUseFallbackServer?: boolean): string;
    /**
     * Return url (with extra url parameters) for validation / partial validation request.
     *
     * @param metaData - Metadata for validation request.
     * @param isPartialValidation - Is this for partial validation request, default is false.
     * @param hasUserChangedLanguage - Has user discard language determined by validation server, default is false.
     */
    private static _getServerFullUrl;
    /**
     * Abort validation request.
     *
     * @param instanceId - Id of instance for which request should be aborted.
     */
    private static _abortValidationRequest;
    /**
     * Abort partial validation request.
     *
     * @param instanceId - Id of instance for which request should be aborted.
     */
    private static _abortPartialValidationRequest;
    /**
     * Prepare text for processing on validation server (replace unsupported chars).
     *
     * @param text - Text for preparation.
     */
    private static _prepareText;
    /**
     * Combines paragraphs into chunks total length of which does not exceed the specified limit.
     *
     * @param paragraphs - Text paragraphs.
     * @param chunkLengthLimit - Chunk size limit.
     */
    private static _joinInChunks;
    /**
     * Return common request data for validation / partial validation request.
     *
     * @param text - Text for validation.
     * @param language - Text language.
     * @param userLanguageCodes - Codes of languages used by user.
     * @param metaData - Metadata for validation request.
     */
    private static _getRequestData;
    private static _getPreferredVariants;
    /**
     * Return request data for validation request.
     *
     * @param text - Text for validation.
     * @param language - Text language.
     * @param userLanguageCodes - Codes of languages used by user.
     * @param metaData - Metadata for validation request.
     */
    private static _getValidationRequestData;
    /**
     * Return request data for partial validation request.
     *
     * @param text - Text for validation.
     * @param language - Text language.
     * @param userLanguageCodes - Codes of languages used by user.
     * @param metaData - Metadata for validation request.
     * @param allowIncompleteResults - Allows validation server to abort validation and return an incomplete list of errors (this mean that probably specified text language is wrong). Server will throw error otherwise.
     */
    private static _getPartialValidationRequestData;
    /**
     * Asynchronously send request to specified url. Reject request after specified count of milliseconds.
     *
     * @param url - Url on which request should be send.
     * @param params - Request parameters.
     * @param lifetime - Request lifetime in milliseconds, default is config.VALIDATION_REQUEST_TIMEOUT.
     */
    private static _sendRequest;
    /**
     * Check is response contains exception data.
     *
     * @param response - Response for validation request.
     */
    private static _checkForException;
    /**
     * Check is exception happened due to connection or timeout issue.
     *
     * @param exception - Exception thrown by validation server.
     */
    private static _isConnectionOrServerIssue;
    /**
     * Return count of graphemes in the text, which together consist of a specified number of codepoints.
     *
     * @param text - Text splitted in graphemes.
     * @param codepointsCount - Codepoints count.
     * @param offset - Index of grapheme to begin with, default is 0.
     */
    private static _getGraphemesCount;
    /**
     * Return count of codepoints which occupied by the specified count of graphemes.
     *
     * @param text - Text splitted in graphemes.
     * @param graphemesCount - Graphemes count.
     * @param offset - Index of grapheme to begin with, default is 0.
     */
    private static _getCodepointsCount;
    /**
     * Correct matches offset and length according to differences between codepoints of text and originalText.
     *
     * @param matches - Matches returned from validation server.
     * @param text - Validated text.
     * @param originalText - Original text equals to validated text but can be partially decomposed.
     */
    private static _correctMatches;
    /**
     * Return context text placed before specified position.
     *
     * @param text - Text.
     * @param end - End position of context text.
     * @param strictByParagraph - Should context be stricted by paragraph.
     * @param count - Maximum count of chars, default is 10.
     */
    private static _getLeftText;
    /**
     * Return context text placed after specified position.
     *
     * @param text - Text.
     * @param start - Start position of context text.
     * @param strictByParagraph - Should context be stricted by paragraph.
     * @param count - Maximum count of chars, default is 10.
     */
    private static _getRightText;
    /**
     * Transform matches returned from validation server to errors used by extension.
     *
     * @param matches - Matches returned from validation server.
     * @param text - Validated text.
     * @param language - Text language.
     * @param isPartialValidation - Is matches found during partial validation, default is false.
     */
    private static _transformMatches;
    /**
     * Filter errors and add extra fixes.
     *
     * @param errors - Errors found in validated text.
     * @param text - Validated text.
     * @param domain - Domain of page for which validation is performed.
     * @param recipientFullName - Fullname of recipient (if available).
     */
    private static _adjustErrors;
    /**
     * Process response received from validation server.
     *
     * @param response - Result received from validation server.
     * @param text - Validated text.
     * @param originalText - Original text equals to validated text but can be partially decomposed.
     * @param metaData - Metadata for validation request.
     * @param isPartialValidation - Is response returned for partial validation request, default is false.
     */
    private static _processResponse;
    /**
     * Correct errors positions (offset) according to paragraphs positions.
     *
     * @param paragraphs - Paragraphs in which errors contains.
     * @param errors - Errors in validated paragraphs.
     */
    private static _correctErrorOffsets;
    /**
     * Asynchronously validate text.
     *
     * @param text - Text for validation.
     * @param language - Text language.
     * @param userLanguageCodes - Codes of languages used by user.
     * @param metaData - Metadata for validation request.
     * @param hasUserChangedLanguage - Has user discard language determined by validation server, default is false.
     */
    static validate(text: string, language: LanguageInfo | null, userLanguageCodes: string[], metaData: ValidationMetaData, hasUserChangedLanguage?: boolean): Promise<ValidationResult>;
    /**
     * Asynchronously validate text paragraphs.
     *
     * @param paragraphs - Text paragraphs for validation.
     * @param language - Text language.
     * @param userLanguageCodes - Codes of languages used by user.
     * @param metaData - Metadata for validation request.
     * @param allowIncompleteResults - Allows validation server to abort validation and return an incomplete list of errors (this mean that probably specified text language is wrong). Server will throw error otherwise.
     */
    static partialValidate(paragraphs: Paragraph[], language: LanguageInfo | null, userLanguageCodes: string[], metaData: ValidationMetaData, allowIncompleteResults?: boolean): Promise<PartialValidationResult>;
    /**
     * Check is user has paid subscription.
     */
    static checkForPaidSubscription(username: string, password: string, token: string): Promise<boolean>;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
declare class DictionarySync {
    private static MAX_WORDS;
    private static readonly _storageController;
    private static _isInitialized;
    private static _syncing;
    private static _deleting;
    private static EMOJI_REGEXP;
    static init(): void;
    private static _isSyncCapable;
    static disableSync(): Promise<void>;
    static checkForInitialSync(): void;
    static addBatch(words: string[]): Promise<unknown>;
    private static _isValidWord;
    static removeBatch(words: string[]): Promise<unknown>;
    static downloadAll(): void;
    private static _getBaseUrl;
    static addWord(word: string, _isRetry?: boolean): Promise<void>;
    static removeWord(word: string, _isRetry?: boolean): Promise<void>;
    private static downloadList;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
interface SynonymResponse {
    synsets: {
        terms: {
            term: string;
        }[];
    }[];
    dataSource: {
        licenseUrl: string;
        sourceName: string;
        sourceUrl: string;
    };
}
interface SynonymObject {
    word: string;
    hints: string[];
}
interface SynonymSet {
    title: string;
    type: string;
    synonyms: SynonymObject[];
}
interface SynonymResult {
    synonymSets: SynonymSet[];
    dataSource: SynonymResponse['dataSource'];
}
interface SynonymCacheEntry {
    word: string;
    beforeText: string;
    afterText: string;
    language: string;
    motherTongue: string;
    result: SynonymResult;
}
declare class Synonyms {
    private static HTTP_TIMEOUT;
    private static _currentRequest;
    private static _timeout;
    private static _cache;
    private static IS_ONLY_HINT_REGEXP;
    private static TERM_REGEXP;
    private static HINT_REGEXP;
    static load(wordContext: WordContextInfo, language: string, motherTongue: string): Promise<SynonymResult>;
    private static _request;
    private static _prepareWord;
    private static _containsSynonymObj;
    private static _buildSynonymSets;
    private static _abortCurrentRequest;
    private static _getFromCache;
    private static _setInCache;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
 * Wrapper which limit invocation of wrapped function. Wrapped function will be invoke with
 * specified delay after last call or with specified max delay after first call.
 */
declare class Debounce<F extends (...args: any[]) => void> {
    /**
     * Wrapped function.
     */
    private readonly _wrappedFunc;
    /**
     * Delay in milliseconds.
     */
    private readonly _delay;
    /**
     * Max delay in millisecond, value no greater than 0 will be treated as no max delay.
     */
    private readonly _maxDelay;
    /**
     * Data which will be passed to wrapped function.
     */
    private _args;
    /**
     * Invocation delay timeout id.
     */
    private _delayTimeoutId;
    /**
     * Invocation max delay timeout id.
     */
    private _maxDelayTimeoutId;
    /**
     * Init new instance with passed function and specified delays.
     *
     * @param wrappedFunc - Wrapped function.
     * @param delay - Delay in milliseconds, default is 250.
     * @param maxDelay - Max delay in milliseconds, value no greater than 0 will be treated as no max delay. Default value is 0.
     */
    constructor(wrappedFunc: F, delay?: number, maxDelay?: number);
    /**
     * Invoke function without delay and cancel planned invocation.
     */
    callImmediately: () => void;
    /**
     * Invoke wrapped function with delay.
     *
     * @param args - Data which will be passed to wrapped function.
     */
    call(...args: Parameters<F>): void;
    /**
     * Discard planned invocations of wrapped function.
     *
     * @param isCallDelayed - Is call only delayed. Default is false.
     */
    cancelCall(isCallDelayed?: boolean): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
 * Traverse through all nodes (dom elements and textnodes) in root node subtree.
 */
declare class DOMWalker {
    /**
     * Root node.
     */
    private readonly _rootNode;
    /**
     * Current node, null if all nodes are traversed.
     */
    private _currentNode;
    /**
     * Create new instace for specified root node and start node.
     *
     * @param rootNode - Root node.
     * @param startNode - Start node, all nodes before this node will be omitted, default is root node.
     */
    constructor(rootNode: Node, startNode?: Node);
    /**
     * Move to next node in subtree and return this node. Return null if there is no any other node.
     *
     * @param skipChilds - If true skip child nodes of current node, default is false.
     */
    next(skipChilds?: boolean): Node | null;
    /**
     * Сurrent node, null if all nodes are traversed.
     */
    node(): Node | null;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
 * Validation statusesю
 */
declare enum VALIDATION_STATUS {
    /**
     * User didn't grant permission for validation.
     */
    PERMISSION_REQUIRED = "PERMISSION_REQUIRED",
    /**
     * Validation isn't turn on (user set autoCheck=false).
     */
    DISABLED = "DISABLED",
    /**
     * Extension has been updated, disabled or uninstalled (page should be refreshed).
     */
    DISCONNECTED = "DISCONNECTED",
    /**
     * Validation can't be performed because text is too short.
     */
    TEXT_TOO_SHORT = "TEXT_TOO_SHORT",
    /**
     * Validation can't be performed because text is too long.
     */
    TEXT_TOO_LONG = "TEXT_TOO_LONG",
    /**
     * Validation request has been sent, but the result has not yet been received.
     */
    IN_PROGRESS = "IN_PROGRESS",
    /**
     * Validation request is completed successfully.
     */
    COMPLETED = "COMPLETED",
    /**
     * Validation can't be performed because language of text is not supported.
     */
    UNSUPPORTED_LANGUAGE = "UNSUPPORTED_LANGUAGE",
    /**
     * Validation request is failed.
     */
    FAILED = "FAILED"
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
interface ParsingOptions {
    element: HTMLElement;
    preserveLineBreaks: boolean;
    preserveWhitespaces: boolean;
}
interface NodeProperties {
    computedStyle: CSSStyleDeclaration;
    isSkippingElement: boolean;
    isElementNode: boolean;
    isBr: boolean;
    isBlock: boolean;
    parsingOptions: ParsingOptions;
    parsedText: string;
    blockParent: HTMLBlockElement;
    paragraphLastNode: Node | null;
    isBRElementRelevant: boolean;
    isBlockElementRelevant: boolean;
    isTextEndsWithLineBreak: boolean;
    isParagraphNonEmpty: boolean;
}
interface CacheInvalidationRuleConditions {
    attributes?: string[];
    characterData?: boolean;
    childList?: boolean;
}
interface CacheInvalidationRule {
    key: keyof NodeProperties;
    self?: CacheInvalidationRuleConditions;
    parent?: CacheInvalidationRuleConditions;
    blockChild?: CacheInvalidationRuleConditions;
    blockSibling?: CacheInvalidationRuleConditions;
    any?: CacheInvalidationRuleConditions;
}
interface ParsingDetector {
    isIgnored: (element: HTMLElement) => boolean;
    isSignature: (element: HTMLElement) => boolean;
    isQuote: (element: HTMLElement) => boolean;
    isBlock: (element: HTMLElement, computedStyle: CSSStyleDeclaration) => boolean;
    isBlockElementRelevant?: (blockElement: HTMLElement) => boolean;
    getParsingOptions?: (element: HTMLElement, ceElementInspector: CEElementInspector) => ParsingOptions;
    replaceText: (text: string, textNode: TextNode, element: HTMLElement) => string;
}
declare class CEElementInspector {
    static readonly DISPLAY_BLOCK_VALUES: string[];
    static readonly SKIPPING_TAGS: string[];
    static readonly SUP_REGEXP: RegExp;
    private static readonly PRESERVE_LINEBREAKS_VALUES;
    private static readonly PRESERVE_WHITESPACES_VALUES;
    private static readonly _cacheInvalidationRules;
    private static readonly LINE_BREAKS_REGEXP;
    private static _replaceLineBreaks;
    private static readonly WHITESPACE_REGEXP;
    private static _joinWhitespaces;
    private static _isBlankString;
    private static cached;
    private readonly _ceElement;
    private readonly _parsingDetector;
    private readonly _enableCache;
    private readonly _cachedNodes;
    private readonly _nodePropertiesCache;
    private readonly _ceElementObserver?;
    constructor(ceElement: CEElement, parsingDetector: ParsingDetector, enableCache?: boolean);
    private _deleteCacheForNode;
    private _normalizeMutations;
    private _checkRuleConditions;
    private _onCEElementChange;
    getComputedStyle(element: HTMLElement): CSSStyleDeclaration;
    isSkippingElement(element: HTMLElement): boolean;
    isElementNode(node: Node): node is HTMLElement;
    isBr(element: HTMLElement): element is HTMLBRElement;
    isBlock(element: HTMLElement): boolean;
    getParsingOptions(node: Node): ParsingOptions;
    getParsedText(textNode: TextNode): string;
    getBlockParent(node: Node): HTMLElement;
    getParagraphLastNode(textNode: TextNode): Node | null;
    isBRElementRelevant(brElement: HTMLBRElement): boolean;
    isBlockElementRelevant(blockElement: HTMLElement): boolean;
    isTextEndsWithLineBreak(textNode: TextNode): boolean;
    isParagraphNonEmpty(blockElement: HTMLBlockElement): boolean;
    destroy(): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
interface TextReplacement {
    textNode: TextNode;
    from: number;
    to: number;
    replacementText: string;
    newText: string;
}
interface TextChunk {
    node: Node;
    isTextNode: boolean;
    rawText: string;
    rawTextOffset: number;
    parsedText: string;
    parsedTextOffset: number;
}
interface TextPosition {
    textNode: TextNode;
    offset: number;
}
interface TextRange {
    textNode: TextNode;
    start: number;
    end: number;
}
interface SelectionInfo {
    start: number;
    end?: number;
}
interface InputAreaWrapperEventDetail {
    inputAreaWrapper: InputAreaWrapper;
}
interface InputAreaWrapperTextChangedDetail extends InputAreaWrapperEventDetail {
    previousText: string;
    text: string;
}
interface InputAreaWrapperScrollDetail extends InputAreaWrapperEventDetail {
}
interface InputAreaWrapperPasteDetail extends InputAreaWrapperEventDetail {
}
interface InputAreaWrapperBlurDetail extends InputAreaWrapperEventDetail {
}
interface InputAreaWrapperDblClickDetail extends InputAreaWrapperEventDetail {
    selectedText: string;
    selection: SelectionInfo;
    clickedRectangles: BoxInterface[];
}
declare class InputAreaWrapper {
    static readonly eventNames: {
        textChanged: string;
        scroll: string;
        paste: string;
        blur: string;
        dblclick: string;
    };
    private static readonly SCROLL_TO_FRAME_INTERVAL;
    private static readonly NBSP;
    private static readonly VISIBLE_WHITE_SPACE_REGEXP;
    private static readonly LEADING_WHITESPACES_REGEXP;
    private static readonly TRAILING_WHITESPACES_REGEXP;
    private static readonly INPUT_AREA_OBSERVER_CONFIG;
    private static _endsWithWhitespace;
    private static _selectText;
    private static _simulateMouseClick;
    private static _simulateSelection;
    private readonly _inputArea;
    private readonly _ceElement;
    private readonly _textLengthThreshold;
    private _textChunks;
    private _currentText;
    private _scrollTop;
    private _scrollLeft;
    private readonly _tweaks;
    private readonly _ceElementInspector;
    private readonly _domMeasurement;
    private readonly _inputAreaObserver;
    private _scrollToInterval;
    private _lastKey;
    constructor(inputArea: InputArea, ceElement: CEElement, tweaks: Tweaks, textLengthThreshold?: number);
    private _getTextChunkIndex;
    private _offsetInRawText;
    private _offsetInParsedText;
    private _updateTextChunks;
    private _getTextPosition;
    private _getTextOffset;
    private _hasSpaceBefore;
    private _hasSpaceAfter;
    private _applyReplacement;
    private _onScroll;
    private _onPaste;
    private _onBlur;
    private _onKeyUp;
    private _onDblClick;
    private _onInput;
    getText(): string;
    getTextRanges(offset: number, length: number): TextRange[];
    replaceText(offset: number, length: number, replacementText: string): Promise<void>;
    simulateInput(text?: string): void;
    simulateChange(): void;
    getSelection(): SelectionInfo | null;
    setSelection(selectionInfo: SelectionInfo): void;
    resetText(): void;
    scrollToText(offset: number, length: number, duration?: number, position?: ScrollIntoViewOptions['block'], callback?: () => void): void;
    destroy(): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
 * Create html clone of TextArea or TextInput, including size, position, text content and font styles.
 * Fired events: input, click.
 */
declare class Mirror {
    /**
     * Container tag name.
     */
    static readonly CONTAINER_ELEMENT_NAME = "lt-mirror";
    /**
     * Names of fired events.
     */
    static readonly eventNames: {
        input: string;
        click: string;
    };
    /**
     * Mimicked element.
     */
    private readonly _mimickedElement;
    /**
     * Element without complicated styles, used only as container for other elements.
     */
    private _container;
    /**
     * Element which copy location and size of mimicked element (contentBox).
     */
    private _wrapper;
    /**
     * Element which copy mimicked element content, has mimicked element scroll width/height.
     */
    private _canvas;
    /**
     * Textarea which used to measure text zoom, see #903.
     */
    private _measurer;
    /**
     * Initial line-height set on mimicked element with inline styles.
     */
    private _elementInlineLineHeight;
    /**
     * Mimicked element computed line-height.
     */
    private _elementComputedLineHeight;
    private _firefoxHackEnabled;
    /**
     * Current wrapper inline styles.
     */
    private _wrapperStyles;
    /**
     * Current mirror text.
     */
    private _currentText;
    /**
     * Helper to work with DOM elements.
     */
    private readonly _domMeasurement;
    /**
     * Resize observer for mimicked element.
     */
    private readonly _mimickedElementResizeObserver;
    /**
     * Animation frame interval used to rerender mirror.
     */
    private readonly _renderInterval;
    private readonly _isRoamResearchIssue;
    private readonly _isHootsuiteIssue;
    private readonly _isDotSyntaxHighlighterIssue;
    /**
     * Init new instance for passed html element.
     *
     * @param mimickedElement - Mimicked element.
     */
    constructor(mimickedElement: TextArea | TextInput);
    /**
     * Fire custom click event with passed details.
     *
     * @param targetElement - Clicked element.
     * @param initEvent - Initial event.
     */
    private _dispatchClick;
    /**
     * Fire custom input event on clone element.
     */
    private _dispatchInput;
    /**
     * Return DOM element before which mirror should be placed.
     */
    private _getTargetElement;
    /**
     * Render all elements (container, wrapper, canvas) and
     * update styles (size, location, font), text content, scrolling.
     */
    private _render;
    /**
     * Return text zoom value, only for firefox.
     *
     * @param clearCache - Should cache be reset, default is false.
     */
    private _getTextZoom;
    /**
     * Return font-size value for wrapper element.
     *
     * @param fontSizeValue - Font-size value of mimicked element.
     */
    private _getWrapperFontSizeValue;
    /**
     * Return white-space value for wrapper element.
     *
     * @param whiteSpaceValue - White-space value of mimicked element.
     */
    private _getWrapperWhiteSpaceValue;
    /**
     * Update scrolling according to mimicked element.
     *
     * @param clearCache - Should cache be reset, default is true.
     */
    private _updateScrolling;
    /**
     * Update text according to mimicked element and fire custom input event if needed.
     */
    private _updateText;
    /**
     * Event handler for mimicked element scroll event.
     */
    private _onMimickedElementScroll;
    /**
     * Event handler for mimicked element click event.
     *
     * @param e - Click event args.
     */
    private _onMimickedElementClick;
    /**
     * Return element which can be used as mimicked element clone.
     */
    getCloneElement(): HTMLElement;
    /**
     * Modifies css styles to allow determining text position.
     * Mirror is visible during this time.
     */
    enableRangeMeasurements(): void;
    /**
     * Modifies css styles to disallow determining text position.
     */
    disableRangeMeasurements(): void;
    /**
     * Unsubscribe all event handlers and remove elements from DOM tree.
     */
    destroy(): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
interface HighlighterAppearance {
    getZIndex: (inputArea: InputArea, domMeasurement: DomMeasurement) => number | "auto";
}
/**
 * Rectangle for drawing on canvas.
 */
interface DrawnRect extends BoxInterface {
    color: string;
    textBox: BoxInterface;
}
/**
 * Minimized version of DrawnRect.
 */
interface DrawnRectMin {
    x: number;
    y: number;
    w: number;
    h: number;
    c: string;
}
/**
 * Dictionary of DrawnRectMin objects.
 */
interface DrawnItems {
    [key: string]: DrawnRectMin;
}
/**
 * Independent highlighting area, used to support oversized inputarea.
 */
interface HighlightingArea {
    /**
     * Part of inputArea associated with this HighlightingArea.
     */
    cell: BoxInterface;
    /**
     * Highlighting area canvas.
     */
    canvas: HTMLCanvasElement;
    /**
     * Canvas size and position, can be null in case when canvas is not in page DOMTree.
     */
    canvasBox?: BoxInterface;
    /**
     * Cached canvas context.
     */
    context: CanvasRenderingContext2D;
    /**
     * Items drawn in highlighting area.
     */
    drawnItems: DrawnItems;
}
/**
 * Highlighted text block.
 */
interface HighlightedBlock {
    /**
     * Unique identificator.
     */
    id: string;
    /**
     * Highlighted block start position in inputarea text.
     */
    offset: number;
    /**
     * Highlighted block text length.
     */
    length: number;
    /**
     * Is highlighted block should be emphasized.
     */
    isEmphasized: boolean;
    /**
     * Emphasize color.
     */
    backgroundColor: string;
    /**
     * Is highlighted block should be underlined.
     */
    isUnderlined: boolean;
    /**
     * Underline color.
     */
    underlineColor: string;
    /**
     * Highlight text block as if it were selected by user.
     */
    simulateSelection?: boolean;
    /**
     * Block text ranges.
     */
    textRanges?: TextRange[];
    /**
     * Text boxes of highlighted block.
     */
    textBoxes?: BoxInterface[];
}
/**
 * Base interface for higlighter event detail.
 */
interface HighlighterEventDetail {
    highlighter: Highlighter;
}
/**
 * BlockClicked event detail.
 */
interface HighlighterBlockClickedDetail extends HighlighterEventDetail {
    /**
     * Id of clicked block.
     */
    blockId: string;
    /**
     * Clicked box, coordinates relative to page.
     */
    clickedBox: BoxInterface;
}
/**
 * Highlight text blocks in inputarea.
 * Fired events: blockClicked.
 */
declare class Highlighter {
    /**
     * Container tag name.
     */
    static readonly CONTAINER_ELEMENT_NAME = "lt-highlighter";
    /**
     * Canvas maximum width in pixels.
     */
    private static readonly CANVAS_MAX_WIDTH;
    /**
     * Canvas maximum height in pixels.
     */
    private static readonly CANVAS_MAX_HEIGHT;
    /**
     * Width of underline in pixels.
     */
    private static readonly LINE_WIDTH;
    /**
     * Names of fired events.
     */
    static readonly eventNames: {
        blockClicked: string;
    };
    /**
     * Target inputarea in which text blocks should be highlighted.
     */
    private readonly _inputArea;
    /**
     * Wrapper of target inputarea.
     */
    private readonly _inputAreaWrapper;
    /**
     * Contenteditable element associated with target inputarea. Can be same as inputarea or mirror clone element.
     */
    private readonly _ceElement;
    /**
     * Is mirror used to create contenteditable element for target inputarea.
     */
    private readonly _isMirror;
    /**
     * Tweaks for current site.
     */
    private readonly _tweaks;
    /**
     * Appearance settings determined by tweaks.
     */
    private readonly _appearance;
    /**
     * Is target inputarea a draft editor, see #444.
     */
    private readonly _isDraftJsIssue;
    /**
     * Is target inputarea a quilljs editor, see #320.
     */
    private readonly _isQuillJsIssue;
    /**
     * Is a target inputarea a shareepoint editor, see #618.
     */
    private readonly _isSharepointIssue;
    /**
     * Is target inputarea a AmoCRM editor, see #768
     */
    private readonly _isAmoCRMIssue;
    /**
     * see #821
     */
    private readonly _isNextcloudTalkIssue;
    /**
     * see #998
     */
    private readonly _isDTFIssue;
    /**
     * Element which has correct z-index, used as container for other elements.
     */
    private _container;
    /**
     * Element which copy location and size of contenteditable element (paddingBox).
     */
    private _wrapper;
    /**
     * Element which contains canvases, used to emulate scrolling.
     */
    private _scrollElement;
    /**
     * Independent highlighting areas, used to support oversized inputarea.
     */
    private _highlightingAreas;
    /**
     * Text in target inputarea on last draw.
     */
    private _highlightedText;
    /**
     * Highlighted text blocks.
     */
    private _highlightedBlocks;
    /**
     * Contenteditable scroll width on last render.
     */
    private _width;
    /**
     * Contenteditable scroll height on last render.
     */
    private _height;
    /**
     * Container z-index value.
     */
    private _currentZIndex;
    /**
     * Helper to work with DOM elements.
     */
    private readonly _domMeasurement;
    /**
     * MutationObserver for contenteditable element.
     */
    private readonly _contentChangedObserver;
    /**
     * Resize observer for contenteditable element.
     */
    private readonly _ceElementResizeObserver;
    /**
     * Animation frame interval used to rerender highlighter.
     */
    private readonly _renderInterval;
    /**
     * Init new instace for passed inputarea.
     *
     * @param inputArea - Target inputarea.
     * @param inputAreaWrapper - Wrapper for target inputarea.
     * @param ceElement - Contenteditable element associated with target inputarea.
     * @param isMirror - Is mirror used to create contenteditable element for target inputarea.
     * @param tweaks - Tweaks for current site.
     */
    constructor(inputArea: InputArea, inputAreaWrapper: InputAreaWrapper, ceElement: HTMLElement | undefined, isMirror: boolean, tweaks: Tweaks);
    /**
     * Convert box coordinates from coordinates relative to element to coordinates relative to page.
     *
     * @param box - Box which coordinates should be converted.
     * @param element - DOM element relative to which box coordinates are defined.
     */
    private _toPageCoordinates;
    /**
     * Convert point coordinates from client area coordinates (https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/clientX) to coordinates relative to element.
     *
     * @param point - Point which coordinates should be converted.
     * @param element - DOM element relative to which point coordinates should be converted.
     */
    private _toElementCoordinates;
    /**
     * Get contenteditable element scroll values.
     *
     * @param withZoom - Should zoom value affect scroll values, default is true.
     * @param withScale - Should scale value affect scroll values, same as withScale by default.
     * @param clearCache - Should DomMeasurement cache be discarded, default is true.
     */
    private _getCEElementScroll;
    /**
     * Return DOM element before which highlighter should be placed.
     */
    private _getTargetElement;
    /**
     * Render container and wrapper and update styles (size, location), scrolling.
     * Redraw canvases content if needed.
     */
    private _render;
    /**
     * Update highlighted areas according to current inputarea scroll size.
     */
    private _updateHighlightedAreas;
    /**
     * Redraw all highlighted boxes on canvas.
     *
     * @param clearCache - Should DomMeasurement cache be discarded, default is true.
     */
    private _redraw;
    /**
     * Update highlightingAreas position according to ceElement scroll values.
     */
    private _applyScrolling;
    /**
     * Event handler for inputarea scroll event.
     */
    private _onInputAreaScroll;
    /**
     * Event handler for contenteditable element click event.
     *
     * @param e - Click event args.
     */
    private _onCEElementClick;
    /**
     * Event handler for contenteditable element mutation event.
     *
     * @param mutations - Mutations.
     */
    private _onContentChanged;
    /**
     * Highlight text blocks in textarea.
     *
     * @param highlightedBlocks - Text blocks which should be highlighted.
     */
    highlight(highlightedBlocks?: HighlightedBlock[]): void;
    /**
     * Return textBoxes associated with specified highlighted block.
     *
     * @param blockId - Highlighted block id.
     */
    getTextBoxes(blockId: string): BoxInterface[];
    /**
     * Unsubscribe all event handlers and remove elements from DOM tree.
     */
    destroy(): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
interface ToolbarState {
    validationStatus: VALIDATION_STATUS;
    errorsCount: number;
    premiumErrorsCount: number;
    isIncompleteResult: boolean;
    validationErrorMessage: string;
}
interface ToolbarAppearance {
    isVisible: (targetElement: HTMLElement, domMeasurement: DomMeasurement, minRequiredHeight?: number) => boolean;
    getPosition: (targetElement: HTMLElement, rootElement: HTMLElement, domMeasurement: DomMeasurement, isRTL: boolean, toolbarSize: Size, minRequiredVisibleHeight?: number, smallInputAreaVisibleHeight?: number) => ToolbarPosition | null;
    getZIndex: (targetElement: HTMLElement, rootElement: HTMLElement, domMeasurement: DomMeasurement) => number | "auto";
    getClassName: (inputArea: InputArea) => string | null;
    hasTurnOff: (inputArea: InputArea) => boolean;
    getTurnOffMessage: (inputArea: InputArea) => string;
}
interface ToolbarPosition {
    fixed: boolean;
    top?: string;
    left?: string;
}
interface ToolbarEventDetail {
    toolbar: Toolbar;
}
interface ToolbarPermissionRequiredIconClickedDetail extends ToolbarEventDetail {
}
interface ToolbarToggleDialogDetail extends ToolbarEventDetail {
}
interface ToolbarNotifyAboutPremiumIconDetail extends ToolbarEventDetail {
}
declare class Toolbar {
    /**
     * Container tag name.
     */
    static readonly CONTAINER_ELEMENT_NAME = "lt-toolbar";
    private static readonly TOOLBAR_SIZE;
    /**
     * Names of fired events.
     */
    static readonly eventNames: {
        permissionRequiredIconClicked: string;
        toggleDialog: string;
        turnOff: string;
        notifyAboutPremiumIcon: string;
    };
    /**
     * Cached localized messages, i18n API will be inaccessible when extension is disconnected.
     */
    private static MESSAGES;
    /**
     * Is Toolbar initialized.
     */
    private static _isInitialized;
    /**
     * Cache localized messages.
     */
    private static _cacheMessages;
    /**
     * Init Toolbar. There is no need to use it in external code.
     */
    static _constructor(): void;
    private readonly _inputArea;
    private readonly _targetElement;
    private readonly _appearance;
    private readonly _mirror;
    private _state;
    private _stateForComparison;
    private _controls;
    private _rootElement;
    private _visible;
    private _destroyed;
    private _sizeDecreased;
    private _hasNotifiedAboutPremiumIcon;
    private readonly _domMeasurement;
    private _eventListeners;
    private readonly _renderInterval;
    private readonly _decreaseSizeInterval;
    private _currentStyles;
    private _animationFrame;
    private _premiumIconTimeout;
    private _renderOutsideIframe;
    private _document;
    private readonly _scrollObserver;
    constructor(inputArea: InputArea, appearence: ToolbarAppearance, mirror?: Mirror | null, state?: ToolbarState);
    private _render;
    private _updateDisplaying;
    private _hide;
    private _show;
    private _decreaseSizeIfNeeded;
    private _decreaseSize;
    private _increaseSize;
    private _notifyAboutPremiumIcon;
    private _onUnload;
    private _onClick;
    private _onTurnOffIconClick;
    updateState(state: ToolbarState): void;
    enableRangeMeasurements(): void;
    disableRangeMeasurements(): void;
    getState(): ToolbarState;
    getContainer(): HTMLElement;
    destroy(): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
interface DialogState {
    validationStatus: VALIDATION_STATUS;
    errors: TextError[];
    premiumErrors: TextError[];
    isIncompleteResult: boolean;
    ignoredErrorsStats: IgnoredErrorsStats;
    validationErrorMessage: string;
}
interface DialogUIOptions {
    disableOptionsPage: boolean;
    disableFeedbackForm: boolean;
    disableRatingTeaser: boolean;
    disableIgnoringRule: boolean;
    disableAddingWord: boolean;
}
interface DialogEventDetail {
    dialog: Dialog;
}
interface DialogTurnOffDetail extends DialogEventDetail {
}
interface DialogEnableHereDetail extends DialogEventDetail {
}
interface DialogEnableEverywhereDetail extends DialogEventDetail {
}
interface DialogLanguageChangedDetail extends DialogEventDetail {
    language: string;
}
interface DialogErrorSelectedDetail extends DialogEventDetail {
    errorId: string | null;
}
interface DialogAddToDictionaryDetail extends DialogEventDetail {
    error: TextError;
}
interface DialogIgnoreRuleDetail extends DialogEventDetail {
    error: TextError;
}
interface DialogTemporarilyIgnoreWordDetail extends DialogEventDetail {
    error: TextError;
}
interface DialogTemporarilyIgnoreRuleDetail extends DialogEventDetail {
    error: TextError;
}
interface DialogMoreDetailsClickedDetail extends DialogEventDetail {
    url: string;
}
interface DialogFixSelectedDetail extends DialogEventDetail {
    error: TextError;
    fixIndex: number;
}
interface DialogOpenOptionsDetail extends DialogEventDetail {
    target?: string;
    ref?: string;
}
interface DialogShowFeedbackFormDetail extends DialogEventDetail {
}
interface DialogDestroyedDetail extends DialogEventDetail {
}
declare class Dialog {
    /**
     * Container tag name.
     */
    static readonly CONTAINER_ELEMENT_NAME = "lt-dialog";
    private static readonly SPACE_TO_SCREEN_EDGE;
    /**
     * Whitespace in the beginning or end of text.
     */
    private static readonly TRAILING_WHITESPACE_REGEXP;
    /**
     * Cached localized messages, i18n API will be inaccessible when extension is disconnected.
     */
    private static readonly MESSAGES;
    /**
     * Names of fired events.
     */
    static readonly eventNames: {
        turnOff: string;
        enableHere: string;
        enableEverywhere: string;
        languageChanged: string;
        errorSelected: string;
        errorHighlighted: string;
        addToDictionaryClicked: string;
        ignoreRuleClicked: string;
        temporarilyIgnoreWordClicked: string;
        temporarilyIgnoreRuleClicked: string;
        moreDetailsClicked: string;
        fixSelected: string;
        openOptions: string;
        showFeedbackForm: string;
        destroyed: string;
    };
    private _toolbarContainer;
    private _languageCode;
    private _document;
    private _state;
    private _uiOptions;
    private _controls;
    private _eventListeners;
    private _inApplyFixMode;
    constructor(toolbarContainer: HTMLElement, languageCode: string | null, state: DialogState, uiOptions: DialogUIOptions);
    private _render;
    private _position;
    private _alignToBottom;
    private _alignToTop;
    private _removeTeaser;
    private _updateContent;
    private _renderInProgressState;
    private _renderCompletedState;
    private _renderErrors;
    private _renderTextTooShortState;
    private _renderNoErrorsState;
    private _renderIgnoredErrorsStats;
    private _renderRatingTeaser;
    private _renderPremiumErrorsTeaser;
    private _renderPremiumState;
    private _renderDisabledState;
    private _renderTextTooLongState;
    private _renderLanguageUnsupportedState;
    private _renderDisconnectedState;
    private _renderFailedState;
    private _onUnload;
    private _onKeydown;
    private _onLanguageChange;
    private _onTurnOffClick;
    private _onOptionsClick;
    private _onIgnoredErrorsClick;
    private _gotoLanguageTool;
    private _showFeedbackForm;
    private _onErrorHighlighted;
    private _onErrorSelected;
    private _onMoreDetailsClick;
    private _onFixClick;
    private _onAddToDictionaryClick;
    private _onIgnoreRuleClick;
    private _onTemporarilyIgnoreWordClick;
    private _onTemporarilyIgnoreRuleClick;
    private _enableEverywhere;
    private _enableHere;
    updateState(state: DialogState): void;
    setCurrentLanguage(code: string): void;
    destroy(): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
interface ErrorCardUIOptions {
    disableIgnoringRule: boolean;
    disableAddingWord: boolean;
    isPremiumAccount: boolean;
    geoIpCountry: string;
    showFooter: boolean;
}
interface ErrorCardEventDetail {
    errorCard: ErrorCard;
}
interface ErrorCardAddToDictionaryDetail extends ErrorCardEventDetail {
    error: TextError;
}
interface ErrorCardIgnoreRuleDetail extends ErrorCardEventDetail {
    error: TextError;
}
interface ErrorCardTemporarilyIgnoreWordDetail extends ErrorCardEventDetail {
    error: TextError;
}
interface ErrorCardTemporarilyIgnoreRuleDetail extends ErrorCardEventDetail {
    error: TextError;
}
interface ErrorCardMoreDetailsClickedDetail extends ErrorCardEventDetail {
    url: string;
}
interface ErrorCardFixSelectedDetail extends ErrorCardEventDetail {
    error: TextError;
    fixIndex: number;
}
interface ErrorCardLanguageChangedDetail extends ErrorCardEventDetail {
    error: TextError;
    language: string;
}
interface ErrorCardBadgeClickedDetail extends ErrorCardEventDetail {
}
interface ErrorCardLogoClickedDetail extends ErrorCardEventDetail {
}
interface ErrorCardDestroyedDetail extends ErrorCardEventDetail {
    error: TextError;
}
/**
 * Show popup with error description, link to external resources (if exist) and
 * controls which allow to apply fix, add word to personal dictionary or turn off associated rule.
 * Fired events: addToDictionaryClicked, ignoreRuleClicked, temporarilyIgnoreWordClicked, temporarilyIgnoreRuleClicked, moreDetailsClicked,
 * fixSelected, badgeClicked, logoClicked, destroyed.
 */
declare class ErrorCard {
    /**
     * Whitespace in the beginning or end of text.
     */
    private static readonly TRAILING_WHITESPACE_REGEXP;
    /**
     * Container tag name.
     */
    static readonly CONTAINER_ELEMENT_NAME = "lt-card";
    /**
     * Names of fired events.
     */
    static readonly eventNames: {
        addToDictionaryClicked: string;
        ignoreRuleClicked: string;
        temporarilyIgnoreWordClicked: string;
        temporarilyIgnoreRuleClicked: string;
        moreDetailsClicked: string;
        fixSelected: string;
        languageChanged: string;
        badgeClicked: string;
        logoClicked: string;
        destroyed: string;
    };
    /**
     * Cached localized messages, i18n API will be inaccessible when extension is disconnected.
     */
    private static MESSAGES;
    /**
     * Is ErrorCard initialized.
     */
    private static _isInitialized;
    /**
     * Cache localized messages.
     */
    private static _cacheMessages;
    /**
     * Init ErrorCard. There is no need to use it in external code.
     */
    static _constructor(): void;
    /**
     * InputArea which contains text with error.
     */
    private readonly _inputArea;
    /**
     * Displayed error.
     */
    private readonly _error;
    /**
     * Options that determine the display of UI elements.
     */
    private readonly _uiOptions;
    /**
     * InputArea (with error or iframe) near which errorCard should be displayed.
     */
    private readonly _referenceArea;
    /**
     * Is errorCard should be rendered outside iframe.
     */
    private readonly _renderOutsideIframe;
    /**
     * Main document.
     */
    private readonly _document;
    /**
     * Element without complicated styles, used only as container for other elements.
     */
    private _container;
    /**
     * Helper to work with DOM elements.
     */
    private readonly _domMeasurement;
    /**
     * Listeners for events.
     */
    private _eventListeners;
    /**
     * Create new popup with error info and show it near targetBox coordinates.
     *
     * @param inputArea - InputArea which contains text with error.
     * @param targetBox - Box near which ErrorCard should be displayed.
     * @param error - Displayed error.
     * @param uiOptions - Options that determine the display of UI elements.
     */
    constructor(inputArea: InputArea, targetBox: BoxInterface, error: TextError, uiOptions: ErrorCardUIOptions);
    /**
     * Render content of ErrorCard (title, more details, fixes, buttons) and set ErrorCard location.
     *
     * @param targetBox - Box near which ErrorCard should be displayed.
     */
    private _render;
    /**
     * Render main content of errorCard.
     *
     * @param innerContainer - Element which should contains main content.
     */
    private _renderContent;
    /**
     * Event handler for badge click event.
     *
     * @param e - Click event args.
     */
    private _onBadgeClicked;
    /**
     * Event handler for logo click event.
     *
     * @param e - Click event args.
     */
    private _onLogoClicked;
    /**
     * Event handler for "more details" button click event.
     *
     * @param e - Click event args.
     */
    private _onMoreDetailsClick;
    /**
     * Event handler for "fix" button click event.
     *
     * @param fixIndex - Index of suggestion the user clicked on.
     * @param e - Click event args.
     */
    private _onFixClick;
    /**
     * Event handler for switch language
     *
     * @param language - Language to change to
     * @param e - Click event args.
     */
    private _onLanguageChange;
    /**
     * Event handler for "add to dictionary" button click event.
     *
     * @param e - Click event args.
     */
    private _onAddToDictionaryClick;
    /**
     * Event handler for "turn off rule" button click event.
     *
     * @param e - Click event args.
     */
    private _onIgnoreRuleClick;
    /**
     * Event handler for "ignore word" button click event.
     *
     * @param e - Click event args.
     */
    private _onTemporarilyIgnoreWordClick;
    /**
     * Event handler for "ignore rule" button click event.
     *
     * @param e - Click event args.
     */
    private _onTemporarilyIgnoreRuleClick;
    /**
     * Event handler for "close" button click event.
     *
     * @param e - Click event args.
     */
    private _onCloseClicked;
    /**
     * Event handler for document key down event.
     *
     * @param ev - Keydown event args.
     */
    private _onKeyDown;
    /**
     * Event handler for page hide event.
     */
    private _onPageHide;
    /**
     * Unsubscribe all event handlers, remove all elements from document content.
     */
    destroy(): void;
}
interface SynonymsCardEventDetail {
    synonymsCard: SynonymsCard;
}
interface SynonymsCardApplyEventDetail extends SynonymsCardEventDetail {
    synonym: string;
    word: string;
    selection: Required<SelectionInfo>;
}
declare class SynonymsCard {
    /**
     * Container tag name.
     */
    static readonly CONTAINER_ELEMENT_NAME = "lt-card";
    /**
     * Names of fired events.
     */
    static readonly eventNames: {
        synonymSelected: string;
        badgeClicked: string;
        logoClicked: string;
        destroyed: string;
    };
    static BLOCK_ID: string;
    /**
     * Cached localized messages, i18n API will be inaccessible when extension is disconnected.
     */
    private static MESSAGES;
    /**
     * Is SynonymsCard initialized.
     */
    private static _isInitialized;
    /**
     * Cache localized messages.
     */
    private static _cacheMessages;
    /**
     * Init SynonymsCard. There is no need to use it in external code.
     */
    static _constructor(): void;
    private readonly MAX_SYNONYMS_PER_ROW;
    /**
     * InputArea which contains word
     */
    private readonly _inputArea;
    private readonly _targetBoxes;
    private readonly _wordContext;
    private readonly _language;
    private readonly _motherLanguage;
    private readonly _hasSubscription;
    private readonly _showFooter;
    private readonly _referenceArea;
    /**
     * Element without complicated styles, used only as container for other elements.
     */
    private _container;
    private _innerContainer;
    private _content;
    private readonly _domMeasurement;
    private readonly _renderOutsideIframe;
    private readonly _document;
    private _eventListeners;
    private _destroyed;
    readonly selection: Required<SelectionInfo>;
    /**
     * Create new popup with synonyms and show it near targetBox coordinates.
     *
     * @param inputArea - InputArea which contains word.
     * @param targetBoxes - Boxes near which SynonymsCard should be displayed.
     * @param selection - Selection in inputarea which contains target word, can be differ from real selection.
     * @param language - Text language.
     * @param word - The word to show synonyms for.
     * @param hasSubscription - Is user has premium account.
     * @param showFooter - Whether footer should be visible
     */
    constructor(inputArea: InputArea, targetBoxes: BoxInterface[], wordContext: WordContextInfo, language: string, motherLanguage: string, hasSubscription: boolean, showFooter: boolean);
    private _renderContainer;
    private _position;
    private _setMessage;
    private _loadSynonyms;
    private _renderContent;
    private _renderSynonyms;
    private _onSynonymClick;
    private _onShowMoreClick;
    /**
     * Event handler for badge click event.
     *
     * @param ev - Click event args.
     */
    private _onBadgeClicked;
    /**
     * Event handler for logo click event.
     *
     * @param ev - Click event args.
     */
    private _onLogoClicked;
    /**
     * Event handler for "close" button click event.
     *
     * @param ev - Click event args.
     */
    private _onCloseClicked;
    /**
     * Event handler for document key down event.
     *
     * @param ev - Keydown event args.
     */
    private _onKeyDown;
    private _onUnload;
    /**
     * Unsubscribe all event handlers, remove all elements from document content.
     */
    destroy(): void;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
/**
 * Represent data on the number of ignored errors.
 */
interface IgnoredErrorsStats {
    /**
     * Count of errors that have been ignored because misspelled words contains in user dictionary.
     */
    byDictionary: number;
    /**
     * Count of errors that have been ignored because associated rule is ignored.
     */
    byRules: number;
}
declare type CheckLevelType = "normal" | "picky" | "hidden-picky";
interface InitElementOptions {
    id?: number | string;
    dictionary?: string[];
    ignoredRules?: IgnoredRule[];
    language?: string;
    checkLevel?: CheckLevelType;
    onDictionaryAdd?: (word: string) => boolean;
    onTemporaryDictionaryAdd?: (word: string) => void;
    onRuleIgnore?: (rule: IgnoredRule) => boolean;
    onTemporaryIgnore?: (rule: IgnoredRule) => void;
    onUpdate?: (state: EditorStateUpdatedDetail) => void;
    onErrorClick?: (error: TextError) => boolean;
}
interface LTAssistantOptions {
    /**
     * Event handler, invoke when LtAssistant instance initialization completed.
     */
    onInit?: (ltAssistant: LTAssistant) => void;
    /**
     * Inputareas which should be initialized immediately.
     */
    initElements?: InputArea | InputArea[];
    /**
     * Should inputareas be initialized when they receive focus, default is false.
     */
    ignoreFocus?: boolean;
    /**
     * Custom validation server url, e.g. 'https://lt.mycompany.com/v2'.
     */
    apiServerUrl?: string;
    /**
     * UI language (not language of validated text).
     */
    localeCode?: string;
    /**
     * Preferred variants for english, german, portuguese and catalan languages.
     * Can be set only for part of languges, e.g. ['de-DE', 'en-US'].
     */
    preferredVariants?: string[];
    /**
     * List of languages that should be preferred during language detection
     * e.g. ["de", "en", "es"]
     */
    preferredLanguages?: string[];
    /**
     * Mother tongue of the user. This setting will enable a variety of L2 rules
     */
    motherTongue?: string;
    /**
     * Custom dictionary, provide strings as array ["XXXX", "yyyy"].
     */
    dictionary?: string[];
    /**
     * Set to true to enable synonyms FROM EXTERNAL SERVICE. Default is false.
     */
    enableSynonyms?: boolean;
    /**
     * Determines whether or not the feature to ignore rules is available to the user. Default is false.
     */
    disableRuleIgnore?: boolean;
    /**
     * Determines whether or not the feature to add new words to dictionary is available to the user. Default is false.
     */
    disableDictionaryAdd?: boolean;
    /**
     * Internal use only: set background color for errors, in addition to underlines.
     */
    emphasizeErrors?: boolean;
    /**
     * Determines whether or not teasers for LanguageTool premium should be shown (for internal use!)
     */
    disablePremiumTeaser?: boolean;
    /**
     * Extension point. Invoke when user ignore rule.
     * Extension method should return true if handle storaging on its own, else LTAssistant will store ignored rule in local storage.
     */
    onRuleIgnore?: (ignoredRule: IgnoredRule, inputArea: InputArea) => boolean;
    /**
     * Extension point. Invoke when user ignore rule.
     * Extension method should return true if handle storaging on its own, else LTAssistant will store new dictionary word in local storage.
     */
    onDictionaryAdd?: (word: string, inputArea: InputArea) => boolean;
    /**
     * Internal use only.
     * Extension point. Invoke when user click on teaser.
     * Extension method should return true if show premium teaser on its own, else LTAssistant will show standart premium teaser.
     */
    onPremiumTeaserClick?: () => boolean;
    /**
     * Event handler, invoke when LTAssistant instance disposed.
     */
    onDestroy?: () => void;
    user?: {
        email: string;
        token: string;
        premium?: boolean;
    };
    dev?: boolean;
}
interface IgnoredItems {
    words: string[];
    rules: IgnoredRule[];
}
/**
 * Inputarea which now support spellcheck.
 */
interface SpellcheckEditor {
    /**
     * Unique id.
     */
    id: string;
    /**
     * Id of group of inputareas, some text fields belong together but have their own instance (e.g. multiple pages in Google Docs).
     */
    groupId: string;
    /**
     * Which profile to use for checking texts
     */
    checkLevel: CheckLevelType;
    /**
     * Validated inputarea.
     */
    inputArea: InputArea;
    /**
     * Custom tweaks for initialized inputarea.
     */
    inputAreaTweaks: InputAreaTweaks;
    /**
     * Inputarea mirror, present only if inputarea is TextArea or TextInput.
     */
    mirror: Mirror | null;
    /**
     * Wrapper for inputarea.
     */
    inputAreaWrapper: InputAreaWrapper;
    /**
     * Inputarea highlighter.
     */
    highlighter: Highlighter;
    /**
     * Toolbar UI-element.
     */
    toolbar: Toolbar | null;
    /**
     * Dialog UI-element, present only if dialog is displayed.
     */
    dialog: Dialog | null;
    /**
     * Error card UI-element, present only if error card is displayed.
     */
    errorCard: ErrorCard | null;
    /**
     * Synonyms card UI-element, present only if synonyms card is displayed.
     */
    synonymsCard: SynonymsCard | null;
    /**
     * Temporary ignored rules.
     */
    ignoredRules: IgnoredRule[];
    /**
     * Temporary ignored words.
     */
    ignoredWords: string[];
    /**
     * Debounce of function which send request to validation server.
     */
    validationDebounce: Debounce<(editor: SpellcheckEditor, text: string, hasUserChangedLanguage: boolean) => Promise<void>>;
    /**
     * Current validation status.
     */
    validationStatus: VALIDATION_STATUS;
    /**
     * Language of validated text. Can be determined by validation server or specified by user.
     */
    language: LanguageInfo | null;
    /**
     * Is user specify text language.
     */
    forceLanguage: boolean;
    /**
     * Is text language supported by validation server.
     */
    isLanguageSupported: boolean;
    /**
     * Is user enabled text auto-check (can be enabled temporary only for this editor).
     */
    isAutoCheckEnabled: boolean;
    /**
     * Is user typing in inputarea.
     */
    isUserTyping: boolean;
    /**
     * Is inputarea text validating.
     */
    isValidating: boolean;
    /**
     * Is text too short for validation.
     */
    isTextTooShort: boolean;
    /**
     * Is text too long for free validation.
     */
    isTextTooLong: boolean;
    /**
     * Error thrown during validation process.
     */
    validationError: ValidationError | {
        message: string;
    } | null;
    /**
     * Timestamp of last validation.
     */
    validationTimestamp: number;
    /**
     * Validated text.
     */
    validatedText: string;
    /**
     * Is validation result incomplete due to a lot of errors in text.
     */
    isIncompleteResult: boolean;
    /**
     * Whether temporary ignored words and rules should be stored in local storage,
     * so user doesn't have to re-ignore after reloading the page
     */
    shouldStoreTemporaryIgnoredItems: boolean;
    /**
     * All errors in validated text.
     */
    errors: TextError[];
    /**
     * Errors in current inputarea text which should be highlighted. It's not necessarily a subset of errors (during typing).
     */
    displayedErrors: TextError[];
    /**
     * Errors which should be ignored during typing.
     */
    pendingErrors: TextError[];
    /**
     * Premium errors in validated text.
     */
    premiumErrors: TextError[];
    /**
     * Picky errors in validated text.
     */
    pickyErrors: TextError[];
    displayedHiddenErrorCount: number;
    /**
     * Id of currently selected error.
     */
    selectedErrorId: string | null;
    /**
     * Id of temporary selecteddisabled error.
     */
    temporaryDisabledErrorId: string | null;
    /**
     * Id of typing mode timeout.
     */
    typingTimeoutId: number | undefined;
    callbacks: {
        onDictionaryAdd?: (word: string) => boolean;
        onRuleIgnore?: (rule: IgnoredRule) => boolean;
        onTemporaryIgnore?: (rule: IgnoredRule) => void;
        onUpdate?: (state: EditorStateUpdatedDetail) => void;
        onErrorClick?: (error: TextError) => boolean;
    };
    /**
     * Statistic info.
     */
    tracking: {
        /**
         * Is information send to server.
         */
        hasTracked: boolean;
        /**
         * Is user saw premium icon.
         */
        sawPremiumIcon: boolean;
        /**
         * Language code of validated text.
         */
        languageCode: string | null;
        /**
         * Is text enough long for validation.
         */
        hasEnoughText: boolean;
        /**
         * Max length of validated text.
         */
        maxTextLength: number;
    };
}
/**
 * StateUpdated event detail.
 */
interface EditorStateUpdatedDetail {
    /**
     * New validation status.
     */
    validationStatus: VALIDATION_STATUS;
    /**
     * Language code of editor text.
     */
    languageCode: string;
    /**
     * Errors in validated text (including ignored rules)
     */
    errors: TextError[];
    /**
     * Displayed errors in validated text.
     */
    displayedErrors: TextError[];
    /**
     * Premium errors in validated text.
     */
    premiumErrors: TextError[];
    /**
     * Picky errors in validated text.
     */
    pickyErrors: TextError[];
    /**
     * Is validation result incomplete due to a lot of errors in text.
     */
    isIncompleteResult: boolean;
    /**
     * Message of error thrown during validation process.
     */
    validationErrorMessage: string;
    /**
     * Text for which errors and status were generated
     */
    validatedText: string;
}
/**
 * Validate compatible inputareas, display UI-elements, couple all functionality together.
 * Fired events: stateUpdated, destroy.
 */
declare class LTAssistant {
    /**
     * Names of fired events.
     */
    static readonly events: {
        UPDATE: string;
        DESTROY: string;
    };
    /**
     * Regexp matches to a string consisting of a single end of sentence character.
     */
    private static readonly PUNCTIUATION_CHAR_REGEXP;
    /**
     * Regexp matches to a completed sentence (it ends with a suitable punctuation character).
     */
    private static readonly COMPLETED_SENTENCE_REGEXP;
    /**
     * Regexp matches to a string consisting only of non-letters characters.
     */
    private static readonly NO_LETTERS_REGEXP;
    /**
     * Return if error may be false (check error contextForSureMatch property).
     *
     * @param error - Checked error.
     * @param text - Text that contains checked error.
     */
    private static _isPendingError;
    /**
     * Return is error text contains in selection (at the beginning or the end).
     *
     * @param error - Checked error.
     * @param selection - Text selection.
     */
    private static _isErrorSelected;
    /**
     * Return changed paragraphs of new text.
     *
     * @param oldText - Old text.
     * @param newText - New text.
     */
    private static _getChangedParagraphs;
    /**
     * Migrate errors (fix offset and length) from validated text to current text. Valuable subsets should be equal.
     * @param errors- List of errors.
     * @param valuableValidatedText - Valuable subset of last validated text.
     * @param valuableText - Valuable subset of current text.
     */
    private static _migrateErrors;
    /**
     * Correct errors offset and lenght according to text parts map.
     *
     * @param errors - Errors for correction.
     * @param partsMap - Text parts map.
     */
    private static _correctErrors;
    /**
     * Modify offset according to changes between old and new texts and filter out errors located in changed text parts.
     *
     * @param oldText - Old text.
     * @param newText - New text.
     * @param errors - Errors in old text.
     * @param allErrors - Don't filter out errors and only modify offsets.
     */
    private static _adjustErrors;
    /**
     * Returns errors that aren't contained in the paragraphs.
     *
     * @param errors - All errors.
     * @param paragraphs - Paragraphs.
     */
    private static _getErrorsOutsideParagraphs;
    /**
     * Return errors that contains in any text part.
     *
     * @param errors - All errors.
     * @param textParts - Text parts.
     */
    private static _getErrorsInsideTextParts;
    /**
     * LTAssistant options.
     */
    private readonly _options;
    /**
     * Tweaks for current site.
     */
    private readonly _tweaks;
    /**
     * Data provider for extension storage.
     */
    private readonly _storageController;
    /**
     * Is content script connected with background script (can send message). It can be disconnected if extension disabled, updated or uninstalled.
     */
    private _isConnected;
    /**
     * Is user allows sending text to a remote server for validation.
     */
    private _isRemoteCheckAllowed;
    /**
     * Original values of inputarea attributes associated with spellсhecking and observer for this inputarea.
     */
    private readonly _spellcheckingAttributesData;
    /**
     * Initialized inputareas which support spellcheck by languagetool service.
     */
    private readonly _editors;
    /**
     * Id of interval used to check extension health.
     */
    private _checkExtensionHealthIntervalId;
    /**
     * Id of interval used to inject content scripts in TinyMCE editor.
     */
    private _fixTinyMCEIntervalId;
    /**
     * Id of timeout used to initialize inputarea.
     */
    private _initElementTimeouts;
    /**
     * Create new instance with passed options.
     *
     * @param tweaks - Tweaks for current site.
     * @param options - LTAssistant options.
     */
    constructor(options?: LTAssistantOptions, tweaks?: Tweaks);
    /**
     * Initialize LTAssistant.
     */
    private _init;
    /**
     * Return validation settings for current main page.
     */
    private _getValidationSettings;
    /**
     * Load content scripts (if needed) in context of active iframe.
     */
    private _fixIframeWithoutContentScripts;
    /**
     * Initialize spellcheck editor instance if element is supported.
     *
     * @param element - HTML element for initialization.
     * @param checkFocus - Check whether the element has focus after some delay. Default is false.
     */
    private _initElement;
    initElement(element: HTMLElement, options?: InitElementOptions): {
        addWord: (word: string) => void;
        addToDictionary: (word: string) => void;
        ignoreRule: (rule: IgnoredRule) => void;
        clearIgnoredRules: () => void;
        clearWords: () => void;
        getText: () => string;
        getLanguage: () => LanguageInfo | null;
        setLanguage: (language: string) => void;
        setCheckLevel: (checkLevel: CheckLevelType) => void;
        getCheckLevel: () => CheckLevelType;
        getElement: () => InputArea;
        getDisplayedErrors: () => TextError[];
        getDisplayedPremiumErrors: () => TextError[];
        getStatus: () => VALIDATION_STATUS;
        getTextBoxes: (error: TextError) => BoxInterface[];
        applyFix: (error: TextError, fixIndex: number) => void;
        scrollToError: (error: TextError, openErrorCard?: boolean, position?: "center" | "nearest", callback?: ((textBoxes: BoxInterface[]) => void) | undefined) => void;
        destroy: () => void;
    };
    updateLanguageOptions(options: {
        motherTongue?: LTAssistantOptions['motherTongue'];
        preferredVariants?: LTAssistantOptions['preferredVariants'];
        preferredLanguages?: string[];
    }): void;
    updateUser(user: {
        email: string;
        token: string;
        premium?: boolean;
        apiServerUrl?: string;
    }): void;
    /**
     * Set which localization language should be used.
     *
     * @param localeCode - Language code, support language variations (like en_GB).
     */
    setLocale(localeCode: string): void;
    /**
     * Discard inputArea's attributes related to spellchecking.
     *
     * @param inputArea - Inputarea.
     */
    private _disableOtherSpellCheckers;
    /**
     * Restore original values of inputarea's attributes related to spellchecking.
     *
     * @param inputArea - Inputarea.
     */
    private _enableOtherSpellCheckers;
    /**
     * Update editor validation status, toolbar and dialog states.
     *
     * @param editor - Spellcheck editor which state should be updated.
     */
    private _updateState;
    /**
     * Reset editor language and start validation.
     *
     * @param editor - Spellcheck editor which language should be updated.
     * @param newLanguage - New editor language.
     */
    private _setLanguage;
    private _setCheckLevel;
    /**
     * Reset some properties to default values.
     *
     * @param editor - Spellcheck editor whose properties should be reset.
     */
    private _resetEditor;
    /**
     * Instantly start validation of editor's text, return true if validation is completed.
     *
     * @param editor - Spellcheck editor for validation.
     */
    private _validateEditor;
    /**
     * Send validation request to background script.
     *
     * @param editor - Spellcheck editor for validation.
     * @param text - Text for validation.
     * @param hasUserChangedLanguage - Is user change text language.
     */
    private _sendValidationRequest;
    /**
     * Event handler for validation result response.
     *
     * @param result - Validation result data.
     * @param valuableText - Valuable validated text.
     * @param validationTimestamp - Timestamp when validation request was sent.
     */
    private _onValidationCompleted;
    /**
     * Event handler for validation aborted (in case when valuable text is not change d).
     *
     * @param editor - Spellchecker editor which validation is aborted.
     * @param valuableValidatedText - Valuable subset of last validated text.
     * @param valuableText - Valuable subset of current text.
     */
    private _onValidationAborted;
    /**
     * Event handler for validation error response.
     *
     * @param error - Validation error data.
     */
    private _onValidationFailed;
    /**
     * Set spellcheck editor to editing mode.
     *
     * @param editor - Spellcheck editor.
     */
    private _startTypingMode;
    /**
     * Set spellcheck editor to normal mode and update highlighter + state.
     *
     * @param editor - Spellcheck editor.
     */
    private _endTypingModeAndUpdateState;
    /**
     * Set spellcheck editor to normal mode.
     *
     * @param editor - Spellcheck editor.
     */
    private _endTypingMode;
    /**
     * Determine and set which errors and premium errors in editor's text should be displayed.
     *
     * @param editor - Spellcheck editor.
     * @param errors - All errors in editor's text.
     * @param premiumErrors - Premium errors in editor's text.
     */
    private _updateDisplayedErrors;
    /**
     * Highlight blocks according to displayedErrors and selectedErrorId.
     *
     * @param editor - Spellcheck editor blocks in which should be highlighted.
     */
    private _highlight;
    /**
     * Set autoCheck as true, enable editor and start validation.
     *
     * @param editor - Spellcheck editor which should be enabled.
     */
    private _enableEditor;
    /**
     * Set autoCheck as false and disable editor.
     *
     * @param editor - Spellcheck editor which should be disabled.
     */
    private _disableEditor;
    /**
     * Track info associated with passed spellcheck editor.
     *
     * @param editor - Spellcheck editor for tracking.
     */
    private _trackEditor;
    /**
     * Remove all UI elements for passed spellcheck editor and dispose it.
     *
     * @param editor - Spellcheck editor for disposing.
     */
    private _destroyEditor;
    /**
     * Show errorCard for passed spellcheck editor.
     *
     * @param editor - Spellcheck editor whose errorCard should be shown.
     * @param error - Error which info should be displayed.
     * @param targetBox - Box near which errorCard should be shown.
     */
    private _showErrorCard;
    /**
     * Hide (dispose) errorCard for each spellcheck editor.
     */
    private _hideAllErrorCards;
    /**
     * Show synonymsCard for passed spellcheck editor.
     *
     * @param editor - Spellcheck editor whose synonymsCard should be shown.
     * @param targetBoxes - Boxes near which synonymsCard should be shown.
     * @param wordContext - Context of word for which synonymsCard should be shown.
     */
    private _showSynonymsCard;
    /**
     * Hide (dispose) synonymsCard for each spellcheck editor.
     */
    private _hideAllSynonymsCards;
    /**
     * Show dialog for passed spellcheck editor.
     *
     * @param editor - Spellcheck editor whose dialog should be shown.
     */
    private _showDialog;
    /**
     * Hide (dispose) dialog for each spellcheck editor.
     */
    private _hideAllDialogs;
    /**
     * Save total count of displayed premium errors on current day.
     *
     * @param editor - Spellcheck editor which statistics should be count.
     */
    private _savePremiumErrorCount;
    /**
     * Calculate count of unique errors that have been ignored.
     *
     * @param errors - All errors.
     */
    private _getIgnoredErrorsStats;
    /**
     * Check is content script can access browser extension API and update status of all spellcheck editors if not.
     */
    private _checkExtensionHealth;
    /**
     * Dispose LTAssistant instance.
     */
    destroy(): void;
    /**
     * Event handler for page loaded event.
     */
    private _onPageLoaded;
    /**
     * Event handler for page hide event.
     */
    private _onPageHide;
    /**
     * Event handler for document focus event.
     *
     * @param e - Focus event args.
     */
    private _onDocumentFocus;
    /**
     * Event handler for document mousemove event
     *
     * @param e - Mousemove event args.
     */
    private _onDocumentMousemove;
    /**
     * Event handler for blurring any element on page
     *
     * @param e - Focusout event args.
     */
    private _onDocumentFocusout;
    /**
     * Event handler for document click event.
     *
     * @param e - Click event args.
     */
    private _onDocumentClick;
    /**
     * Event handler for inputarea double click event.
     *
     * @param e - Double click event args.
     */
    private _onInputDblClick;
    /**
     * Event handler for inputarea text changed event.
     *
     * @param e - Text changed event args.
     */
    private _onInputTextChanged;
    /**
     * Event handler for inputarea scroll event.
     */
    private _onInputScroll;
    /**
     * Event handler for highlighter block clicked event.
     *
     * @param e - Block clicked event args.
     */
    private _onHiglighterBlockClicked;
    /**
     * Event handler for toolbar permission required icon clicked event.
     */
    private _onToolbarPermissionRequiredIconClicked;
    /**
     * Event handler for toolbar toggle dialog event.
     *
     * @param e - Toggle dialog event args.
     */
    private _onToolbarToggleDialog;
    /**
     * Event handler for toolbar notify about premium icon event.
     *
     * @param e - Notify about premium icon event args.
     */
    private _onToolbarNotifyAboutPremiumIcon;
    /**
     * Event handler for dialog turn off clicked event.
     *
     * @param e - Turn off clicked event args.
     */
    private _onToolbarTurnOffClicked;
    /**
     * Event handler for dialog enable here event.
     *
     * @param e - Enable here event args.
     */
    private _onDialogEnableHere;
    /**
     * Event handler for dialog enable everywhere event.
     *
     * @param e - Enable everywhere event args.
     */
    private _onDialogEnableEverywhere;
    /**
     * Event handler for dialog language changed event.
     *
     * @param e - Language changed event args.
     */
    private _onDialogLanguageChanged;
    /**
     * Event handler for errorCard language changed event.
     *
     * @param e - Language changed event args.
     */
    private _onErrorCardLanguageChanged;
    /**
     * Event handler for dialog error highlighted event.
     *
     * @param e - Error selected event args.
     */
    private _onDialogErrorHighlighted;
    /**
     * Event handler for dialog error selected event.
     *
     * @param e - Error selected event args.
     */
    private _onDialogErrorSelected;
    /**
     * Method that allows to scroll to an error
     *
     * @param editor
     * @param error
     * @param openErrorCard whether error card should be shown once scrolled (default: false)
     */
    private _scrollToError;
    /**
     * Method that deselects the currently selected error
     *
     * @param editor
     */
    private _unselectError;
    /**
     * Event handler for dialog or errorCard add to dictionary event.
     *
     * @param e - Add to dictionary event args.
     */
    private _onAddToDictionary;
    private _addToDictionary;
    /**
     * Event handler for dialog or errorCard ignore rule event.
     *
     * @param e - Ignore rule event args.
     */
    private _onIgnoreRule;
    /**
     * Event handler for dialog or errorCard temporarily ignore work event.
     *
     * @param e - Temporarily ignore word event args.
     */
    private _onTemporarilyIgnoreWord;
    private _temporarilyIgnoreWord;
    /**
     * Event handler for dialog or errorCard temporarily ignore rule event.
     *
     * @param e - Temporarily ignore rule event args.
     */
    private _onTemporarilyIgnoreRule;
    private _temporarilyIgnoreRule;
    private _clearTemporarilyIgnoredRules;
    private _clearWords;
    /**
     * Event handler for dialog or errorCard more details clicked event.
     *
     * @param e - More details clicked event args.
     */
    private _onMoreDetailsClicked;
    /**
     * Event handler for dialog or errorCard fix selected event.
     *
     * @param e - Fix selected event args.
     */
    private _onFixSelected;
    private _applyFix;
    /**
     * Event handler for dialog open options event.
     *
     * @param e - Open options event args.
     */
    private _onDialogOpenOptions;
    /**
     * Event handler for dialog show feedback form event.
     *
     * @param e - Show feedback form event args.
     */
    private _onDialogShowFeedbackForm;
    /**
     * Event handler for dialog destroyed event.
     *
     * @param e - Destroyed event args.
     */
    private _onDialogDestroyed;
    /**
     * Event handler for errorCard or synonymsCard badge clicked event.
     */
    private _onBadgeClicked;
    /**
     * Event handler for errorCard or synonymsCard logo clicked event.
     */
    private _onLogoClicked;
    /**
     * Event handler for errorCard destroyed event.
     *
     * @param e - Destroyed event args.
     */
    private _onErrorCardDestroyed;
    /**
     * Event handler for synonymsCard apply event.
     *
     * @param e - Apply event args.
     */
    private _onSynonymSelected;
    /**
     * Event handler for synonymsCard destroyed event.
     *
     * @param e - Destroyed event args.
     */
    private _onSynonymsCardDestroyed;
    /**
     * Event handler for storage controller settings changed event.
     *
     * @param changes - Settings changed event args.
     */
    private _onSettingsChanged;
    /**
     * Event handler for storage controller privacy settings changed event.
     *
     * @param changes - Privacy settings changed event args.
     */
    private _onPrivacySettingsChanged;
    /**
     * Event handler for storage controller UI state changed event.
     *
     * @param changes - UI state changed event args.
     */
    private _onUiStateChanged;
    private _onDestroy;
}
/*! (C) Copyright 2020 LanguageTooler GmbH. All rights reserved. */
declare module "@languagetooler-gmbh/languagetool-script" {
    export interface LTAssistantUpdateEvent extends EditorStateUpdatedDetail {
    }
    export interface LTAssistantTextError extends TextError {
    }
    export interface LTAssistantIgnoredRule extends IgnoredRule {
    }
    export type LTAssistantEditor = ReturnType<LTAssistant['initElement']>;
    export default LTAssistant;
}
