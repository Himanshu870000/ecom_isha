({
    datafactory : function(component, event, helper) {
        var AvailableSlotlist = [
            {"SlotStartTime": "01/07/2023, 09:00","SlotEndTime": "01/07/2023, 09:30", "SlotBookedOrNot": "Available" },
            {"SlotStartTime": "01/07/2023, 09:30","SlotEndTime": "01/07/2023, 10:00", "SlotBookedOrNot": "Booked" },
            {"SlotStartTime": "01/07/2023, 10:00","SlotEndTime": "01/07/2023, 10:30", "SlotBookedOrNot": "Booked" },
            {"SlotStartTime": "01/07/2023, 10:30","SlotEndTime": "01/07/2023, 11:00", "SlotBookedOrNot": "Available" },
            {"SlotStartTime": "01/07/2023, 11:00","SlotEndTime": "01/07/2023, 11:30", "SlotBookedOrNot": "Available" },
            {"SlotStartTime": "01/07/2023, 11:30","SlotEndTime": "01/07/2023, 12:00", "SlotBookedOrNot": "Available" },
            {"SlotStartTime": "01/07/2023, 12:00","SlotEndTime": "01/07/2023, 12:30", "SlotBookedOrNot": "Booked" },
            {"SlotStartTime": "01/07/2023, 12:30","SlotEndTime": "01/07/2023, 13:00", "SlotBookedOrNot": "Available" },
            {"SlotStartTime": "01/07/2023, 13:00","SlotEndTime": "01/07/2023, 13:30", "SlotBookedOrNot": "Available" },
            {"SlotStartTime": "01/07/2023, 13:30","SlotEndTime": "01/07/2023, 14:00", "SlotBookedOrNot": "Booked" },
            {"SlotStartTime": "01/07/2023, 14:00","SlotEndTime": "01/07/2023, 14:30", "SlotBookedOrNot": "Available" },
            {"SlotStartTime": "01/07/2023, 14:30","SlotEndTime": "01/07/2023, 15:00", "SlotBookedOrNot": "Available" },
            {"SlotStartTime": "01/07/2023, 15:00","SlotEndTime": "01/07/2023, 15:30", "SlotBookedOrNot": "Booked" },
            {"SlotStartTime": "01/07/2023, 15:30","SlotEndTime": "01/07/2023, 16:00", "SlotBookedOrNot": "Booked" },
            {"SlotStartTime": "01/07/2023, 16:00","SlotEndTime": "01/07/2023, 16:30", "SlotBookedOrNot": "Available" },
            {"SlotStartTime": "01/07/2023, 16:30","SlotEndTime": "01/07/2023, 17:00", "SlotBookedOrNot": "Booked" },
            {"SlotStartTime": "01/07/2023, 17:00","SlotEndTime": "01/07/2023, 17:30", "SlotBookedOrNot": "Available" },
            {"SlotStartTime": "01/07/2023, 17:30","SlotEndTime": "01/07/2023, 18:00", "SlotBookedOrNot": "Booked" },
            {"SlotStartTime": "01/07/2023, 18:00","SlotEndTime": "01/07/2023, 18:30", "SlotBookedOrNot": "Available" },
            {"SlotStartTime": "01/07/2023, 18:30","SlotEndTime": "01/07/2023, 19:00", "SlotBookedOrNot": "Available" },
            
        ]
            component.set("v.BookedAndAvailbleSlots",AvailableSlotlist);
            
            }
            })