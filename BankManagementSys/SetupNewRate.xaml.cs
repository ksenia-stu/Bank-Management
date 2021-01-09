﻿using SharedCode;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace BankManagementSys
{
    /// <summary>
    /// Interaction logic for SetupNewRate.xaml
    /// </summary>
    public partial class SetupNewRate : Window
    {
        Account currentAccount;
        public SetupNewRate(Account account)
        {
            InitializeComponent();
            currentAccount = account;
            if (currentAccount.AccountType.Description == "Checking") 
            {
                lblInformation.Content = "New monthly fee rate:";
            }
            else if (currentAccount.AccountType.Description == "Savings")
            {
                lblInformation.Content = "New interest rate:";
            }
        }

        private void btOK_Click(object sender, RoutedEventArgs e)
        {
            if (!AreFieldsValid()) 
            {
                return;
            }

            MessageBoxResult result = MessageBox.Show("Are you sure you would like to setup the new rate for this " + currentAccount.AccountType.Description + " account at " + tbNewRate.Text + "?", "Confirmation required", MessageBoxButton.YesNo, MessageBoxImage.Question);
            if (result == MessageBoxResult.Yes) 
            {
                if (currentAccount.AccountType.Description == "Checking")
                {
                    currentAccount.MonthlyFee = decimal.Parse(tbNewRate.Text);
                    try
                    {
                        EFData.context.SaveChanges();
                        
                    } 
                    catch (SystemException ex)
                    {
                        MessageBox.Show("Database error: " + ex.Message, "Database operation failed", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }
                else if (currentAccount.AccountType.Description == "Savings")
                {
                    currentAccount.Interest = decimal.Parse(tbNewRate.Text);
                }
            }

            DialogResult = true;
        }

        private bool AreFieldsValid()
        {
            if (tbNewRate.Text.Length == 0)
            {
                MessageBox.Show("The new rate field cannot be empty.", "Action required", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }

            decimal interestFee;
            try
            {
                interestFee = decimal.Parse(tbNewRate.Text);
                if (interestFee <= 0)
                {
                    MessageBox.Show("The new rate must not be 0 or negative", "Input error", MessageBoxButton.OK, MessageBoxImage.Error);
                    return false;
                }

                if (interestFee > 20)
                {
                    MessageBox.Show("The new rate must not be higher than 20", "Input error", MessageBoxButton.OK, MessageBoxImage.Error);
                    return false;
                }
            }
            catch (FormatException)
            {
                MessageBox.Show("The new rate must contain only digits and . symbol", "Input error", MessageBoxButton.OK, MessageBoxImage.Error);
                return false;
            }
            return true;
        }

        private void DecimalInput(KeyEventArgs e)
        {
            switch (e.Key)
            {
                case Key.NumPad0:
                case Key.NumPad1:
                case Key.NumPad2:
                case Key.NumPad3:
                case Key.NumPad4:
                case Key.NumPad5:
                case Key.NumPad6:
                case Key.NumPad7:
                case Key.NumPad8:
                case Key.NumPad9:
                case Key.D0:
                case Key.D1:
                case Key.D2:
                case Key.D3:
                case Key.D4:
                case Key.D5:
                case Key.D6:
                case Key.D7:
                case Key.D8:
                case Key.D9:
                case Key.OemPeriod:
                case Key.Decimal:
                    break;
                default:
                    e.Handled = true;
                    break;
            }
        }

        private void tbNewRate_KeyDown(object sender, KeyEventArgs e)
        {
            DecimalInput(e);
        }
    }
}
