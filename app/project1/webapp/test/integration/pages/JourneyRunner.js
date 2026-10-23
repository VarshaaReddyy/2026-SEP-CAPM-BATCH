sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project1/test/integration/pages/PurchaseOrderSrvList.gen",
	"project1/test/integration/pages/PurchaseOrderSrvObjectPage.gen",
	"project1/test/integration/pages/PurchaseItemsSrvObjectPage.gen"
], function (JourneyRunner, PurchaseOrderSrvListGenerated, PurchaseOrderSrvObjectPageGenerated, PurchaseItemsSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project1') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrderSrvListGenerated: PurchaseOrderSrvListGenerated,
			onThePurchaseOrderSrvObjectPageGenerated: PurchaseOrderSrvObjectPageGenerated,
			onThePurchaseItemsSrvObjectPageGenerated: PurchaseItemsSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

