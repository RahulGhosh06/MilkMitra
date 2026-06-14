package com.milkmitra.utils;

import java.time.LocalDate;

import com.milkmitra.model.PaymentSummary;

public class PaymentCycleUtil {

    public static PaymentSummary getCurrentCycle() {

        LocalDate today = LocalDate.now();

        PaymentSummary summary =
                new PaymentSummary();

        int day = today.getDayOfMonth();

        if(day >= 1 && day <= 10) {

            summary.setCycleStart(
                    today.withDayOfMonth(1));

            summary.setCycleEnd(
                    today.withDayOfMonth(10));
        }
        else if(day >= 11 && day <= 20) {

            summary.setCycleStart(
                    today.withDayOfMonth(11));

            summary.setCycleEnd(
                    today.withDayOfMonth(20));
        }
        else {

            summary.setCycleStart(
                    today.withDayOfMonth(21));

            summary.setCycleEnd(
                    today.withDayOfMonth(
                            today.lengthOfMonth()));
        }

        return summary;
    }
}