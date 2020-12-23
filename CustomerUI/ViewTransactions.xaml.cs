﻿using SharedCode;
using Syncfusion.Pdf;
using Syncfusion.Pdf.Graphics;
using Syncfusion.Pdf.Grid;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
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

namespace CustomerUI
{
    /// <summary>
    /// Interaction logic for ViewTransactions.xaml
    /// </summary>
    public partial class ViewTransactions : Window
    {
        List<string> transactionHistoryDays = new List<string> { "7 days", "30 days", "60 days" };
        
        public ViewTransactions()
        {
            InitializeComponent();
            comboHistory.Items.Add("7 days");
            comboHistory.Items.Add("30 days");
            comboHistory.Items.Add("60 days");

            
            lblLoggedInAs.Content = string.Format("Logged as {0} {1}", Utils.login.User.FirstName,
                Utils.login.User.LastName);
      
            comboAccountType.ItemsSource = Utils.login.User.Accounts;
            comboAccountType.DisplayMemberPath = "AccountType.Description";
            
            if (Utils.login.User.Accounts.Count == 0)
            {
                lblError.Content = "There's no bank account linked to your profile yet.";
                return;
            }
           
        }

        private void SortTransactionsByTypeAndDate()
        {
            List<Transaction> sortedTransactions = new List<Transaction>();

            //by type
            if (rbTransactAll.IsChecked == true)
            { 
                sortedTransactions = Utils.userTransactions;
                //by date
                sortedTransactions = SortTransactionsByDate(sortedTransactions);
            }
            else if (rbTransacDeposits.IsChecked == true)
            {
                sortedTransactions = Utils.userTransactions.Where(t => t.Type == "Deposit").ToList();
                //by date
                sortedTransactions = SortTransactionsByDate(sortedTransactions);
            }
            else if (rbTransacWithdrawals.IsChecked == true)
            {
                sortedTransactions = Utils.userTransactions.Where(t => t.Type == "Withdrawal").ToList();
                //by date
                sortedTransactions = SortTransactionsByDate(sortedTransactions);
            }
            else if (rbTransacTransfers.IsChecked == true)
            {
                sortedTransactions = Utils.userTransactions.Where(t => t.Type == "Transfer").ToList();
                //by date
                sortedTransactions = SortTransactionsByDate(sortedTransactions);
            }
            else if (rbTransacPayments.IsChecked == true)
            {
                sortedTransactions = Utils.userTransactions.Where(t => t.Type == "Payment").ToList();
                //by date
                sortedTransactions = SortTransactionsByDate(sortedTransactions);
            }
            else
            {
                sortedTransactions = Utils.userTransactions;
                //by date
                sortedTransactions = SortTransactionsByDate(sortedTransactions);
            }
            lvTransactions.ItemsSource = sortedTransactions;
        }

        private List<Transaction> SortTransactionsByDate(List<Transaction> list)
        {
            if (comboHistory.SelectedIndex == 0)
            {
                return list = list.FindAll(t => (DateTime.Now - t.Date).TotalDays <= 7);
            }
            else if (comboHistory.SelectedIndex == 1)
            {
                return list = list.FindAll(t => (DateTime.Now - t.Date).TotalDays <= 30);
            }
            else if (comboHistory.SelectedIndex == 2)
            {
                return list = list.FindAll(t => (DateTime.Now - t.Date).TotalDays <= 60);
            }
            else
            {
                return list;
            }
        }

        private void btShowTransactionsClicked(object sender, RoutedEventArgs e)
        {
            Account selectedAcc = (Account)comboAccountType.SelectedItem;
            if (selectedAcc == null)
            {
                MessageBox.Show("Please choose an acount to view transactions");
                return;
            }

            Utils.userTransactions = EFData.context.Transactions.Where(t => t.AccountId ==
            selectedAcc.Id).ToList();
            

            SortTransactionsByTypeAndDate();
            comboHistory.SelectedIndex = 0;

        }

        private void RadioButton_Checked(object sender, RoutedEventArgs e)
        {
            SortTransactionsByTypeAndDate(); 
        }

        

        private void comboHistory_SelectionChanged_1(object sender, SelectionChangedEventArgs e)
        {
            SortTransactionsByTypeAndDate();  
        }

        private void btBackToDash_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = true;
        }

        private void btMakeTransfer_Click(object sender, RoutedEventArgs e)
        {
            MakeTransfer transfer = new MakeTransfer();
            transfer.Show();
        }

        private void btMakePayment_Click(object sender, RoutedEventArgs e)
        {
            MakePayment payment = new MakePayment();
            payment.Show();
        }

        private void btPDF_Click(object sender, RoutedEventArgs e)
        {
            /*using (PdfDocument document = new PdfDocument())
            {
                //Add a page to the document
                PdfPage page = document.Pages.Add();

                //Create PDF graphics for a page
                PdfGraphics graphics = page.Graphics;

                //Set the standard font
                PdfFont font = new PdfStandardFont(PdfFontFamily.Helvetica, 20);

                //Draw the text
                graphics.DrawString("Hello World!!!", font, PdfBrushes.Black, new PointF(0, 0));

                //Save the document
                document.Save("Output.pdf");

                // TO FIX: Open dialog to choose file name and where to save
                // TO FIX: Put WPF content in the PDF
            
            }*/

            try
            {

                //Create a new PDF document.
                PdfDocument doc = new PdfDocument();
                //Add a page.
                PdfPage page = doc.Pages.Add();
                //Create a PdfGrid.
                PdfGrid pdfGrid = new PdfGrid();
                //Create a DataTable.
                DataTable dataTable = new DataTable();
                //Add columns to the DataTable
                dataTable.Columns.Add("Transaction Type");
                dataTable.Columns.Add("Date");
                dataTable.Columns.Add("Amount");
                //Add rows to the DataTable.
                foreach (Transaction t in lvTransactions.Items)
                {
                    dataTable.Rows.Add(new object[] { t.Type, t.Date, t.Amount });
                }
                //Assign data source.
                pdfGrid.DataSource = dataTable;
                //Draw grid to the page of PDF document.
                pdfGrid.Draw(page, new PointF(10, 10));
                //Save the document.
                doc.Save("Output.pdf");
                //close the document
                doc.Close(true);

                // TO FIX: Add account holder and balance.
                // TO FIX: Open dialog to choose where to save file.
            }
            catch (IOException ex)
            {
                MessageBox.Show(ex.Message + "Error");
            }
        }
    }
}