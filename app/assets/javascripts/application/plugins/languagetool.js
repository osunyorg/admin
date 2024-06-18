/*global LTAssistant */
document.initLanguageTool = function () {
    'use strict';
    var contentApp = document.getElementById('app'),
        options = {
            localeCode: contentApp.dataset.languagetoolLocale,
            disableRuleIgnore: true,
            disableDictionaryAdd: true,
            user: {
                email: contentApp.dataset.languagetoolEmail,
                token: contentApp.dataset.languagetoolToken,
                premium: true
            },
            apiServerUrl: 'https://api.languagetoolplus.com/v2'
        };
    new LTAssistant(options);
};
