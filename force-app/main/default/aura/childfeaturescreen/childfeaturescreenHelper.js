({
    helperMethod: function (component) {
        debugger;
        console.log('attribute::' + component.get('v.categorieType'));
        console.log('Tested::');

        var catName = component.get('v.categorieType');
        const featureList = component.get('v.featureList');
        const tempList = [];
        for (var i = 0; i < featureList.length;i++){
            if (featureList[i].Category__c == catName) {
                tempList.push(featureList[i]);
                component.set('v.tempList', tempList);
            }
        }
    }
})