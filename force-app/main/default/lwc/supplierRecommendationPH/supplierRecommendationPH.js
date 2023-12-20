import { LightningElement } from 'lwc';
import SP_ONE_PNG from '@salesforce/resourceUrl/supplier_recommendation_one';
import SP_TWO_PNG from '@salesforce/resourceUrl/supplier_recommendation_two';

export default class SupplierRecommendationPH extends LightningElement {
    // Expose the static resource URL for use in the template
    sp_one_img = SP_ONE_PNG;

    // Expose URL of assets included inside an archive file
    sp_two_img = SP_TWO_PNG;
}