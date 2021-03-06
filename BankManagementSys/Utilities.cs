﻿using SharedCode;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace BankManagementSys
{
    public class Utilities
    {
        public static MainWindow mainWindow; // login window
        public static Window adminDashboard;

        public static Login login;
        public static List<string> Countries = new List<string> { "Canada", "USA" };
        public static List<string> transactionHistoryDays = new List<string> { "7 days", "30 days", "60 days" };
        public static List<string> paymentCategories = new List<string> { "Select category","Utility bills", "Education", "Groceries", "Government", "Transportation", "Leisure", "Other" };
        public static List<User> Payees;
        public static List<Transaction> Transactions;
    }
}
