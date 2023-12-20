import { LightningElement, track, api,wire } from 'lwc';
export default class OrderStatus extends LightningElement {

   @track currentStatus = 'Order Placed';
    estimatedDelivery = 'October 15, 2023'; // You can replace this with a dynamic value.

    getStatusClass(status) {
        return status === this.currentStatus ? 'active' : '';
    }

    
}