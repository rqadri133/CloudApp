using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FastMember;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;


namespace TransactionDiagnosticTest
{
    class Program
    {

        public class  TempData
        {
     
                   
            public Guid? TestValueID
            {
                get;
                set;

            }

            public decimal TestValueData
            {
                get;
                set;

            }
            

            public string CreatedBy
            {
                get;
                set;

            }

        }

        /*
         

         
         */

        #region "private connection sql"
        private static void DumpData(DataTable tbl , SqlConnection connection)
        {
        
            SqlCommand command = new SqlCommand("spAddTestDataAll", connection);
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 120;
            SqlParameter param =  command.Parameters.AddWithValue("@TestDataTbl", tbl);
             param.SqlDbType = SqlDbType.Structured;
            command.ExecuteNonQuery();
   

        }
        #endregion

        private static void InsertBIGDATA()
        {

            Random rand = null;
            int count = 0;

            List<TempData> temps = new List<TempData>();

            for (int i = 0; i < 1000000; i++)
            {
                rand = new Random(10001);
                temps.Add(new TempData() { TestValueID = Guid.NewGuid(), TestValueData = Convert.ToDecimal(rand.NextDouble() * 1000000 + 1), CreatedBy = "SYSTEM" });
            }
            count = temps.Count;

            List<TempData> temptest1 = new List<TempData>();
            

            for (int i = 0; i < 1000000; i++)
            {
                rand = new Random(10001);
                temptest1.Add(new TempData() { TestValueID = Guid.NewGuid(), TestValueData = Convert.ToDecimal(rand.NextDouble() * 1000000 + 1), CreatedBy = "SYSTEM" });
            }

            count = count + temptest1.Count;


            List<TempData> temptest2 = new List<TempData>();

            for (int i = 0; i < 1000000; i++)
            {
                rand = new Random(10001);
                temptest2.Add(new TempData() { TestValueID = Guid.NewGuid(), TestValueData = Convert.ToDecimal(rand.NextDouble() * 1000000 + 1), CreatedBy = "SYSTEM" });
            }

            count = count + temptest2.Count;

            List<TempData> temptest3 = new List<TempData>();


            for (int i = 0; i < 1000000; i++)
            {
                rand = new Random(10001);
                temptest3.Add(new TempData() { TestValueID = Guid.NewGuid(), TestValueData = Convert.ToDecimal(rand.NextDouble() * 1000000 + 1), CreatedBy = "SYSTEM" });
            }

            count = count + temptest3.Count;

            List<TempData> temptest4 = new List<TempData>();


            for (int i = 0; i < 1000000; i++)
            {
                rand = new Random(10001);
                temptest4.Add(new TempData() { TestValueID = Guid.NewGuid(), TestValueData = Convert.ToDecimal(rand.NextDouble() * 1000000 + 1), CreatedBy = "SYSTEM" });
            }

            count = count + temptest4.Count;

            List<TempData> temptest5 = new List<TempData>();


            for (int i = 0; i < 1000000; i++)
            {
                rand = new Random(10001);
                temptest5.Add(new TempData() { TestValueID = Guid.NewGuid(), TestValueData = Convert.ToDecimal(rand.NextDouble() * 1000000 + 1), CreatedBy = "SYSTEM" });
            }

            count = count + temptest5.Count;

            List<TempData> temptest6 = new List<TempData>();


            for (int i = 0; i < 1000000; i++)
            {
                rand = new Random(10001);
                temptest6.Add(new TempData() { TestValueID = Guid.NewGuid(), TestValueData = Convert.ToDecimal(rand.NextDouble() * 1000000 + 1), CreatedBy = "SYSTEM" });
            }

            count = count + temptest6.Count;

            Random rnd = new Random();
            System.Diagnostics.Stopwatch timer = new System.Diagnostics.Stopwatch();

            int val = rnd.Next(int.MaxValue / 1000);

            timer.Start();
            long startTimer = timer.ElapsedMilliseconds;
            

            Console.WriteLine("INSERTING TOTAL NUMBER OF RECORDS..." + count);

            Console.WriteLine("Begin process elapsed now..." + startTimer );
            SqlConnection connection = new SqlConnection(System.Configuration.ConfigurationManager.AppSettings["connection"]);
            connection.Open();

            Parallel.Invoke(() =>
            {
                Console.WriteLine("Begin first task time elapsed now...");
                Console.WriteLine(timer.ElapsedMilliseconds);
                MakeTransaction(temps , connection);
                Console.WriteLine("Ending first task time elapsed now...");

                Console.WriteLine(timer.ElapsedMilliseconds);
            },  // close first Action

                             () =>
                             {
                                 Console.WriteLine("Begin second task...");
                                 Console.WriteLine(timer.ElapsedMilliseconds);
                                 MakeTransaction(temptest1,connection);
                                 Console.WriteLine("Ending second task time elapsed now...");
                                 Console.WriteLine(timer.ElapsedMilliseconds);
                             }, //close second Action

                             () =>
                             {
                                 Console.WriteLine("Begin third task time elapsed till now...");
                                 Console.WriteLine(timer.ElapsedMilliseconds);
                                 MakeTransaction(temptest2,connection);
                                 Console.WriteLine("Ending third task time elapsed till now...");

                                 Console.WriteLine(timer.ElapsedMilliseconds);
                             } //close third Action
                             ,

                                   () =>
                             {
                Console.WriteLine("Begin fourth task time elapsed till now...");
                Console.WriteLine(timer.ElapsedMilliseconds);
                MakeTransaction(temptest3,connection);
                Console.WriteLine("Ending fourth task time elapsed till now...");

                Console.WriteLine(timer.ElapsedMilliseconds);
            } , //close third Action
            () =>
            {
                Console.WriteLine("Begin fourth task time elapsed till now...");
                Console.WriteLine(timer.ElapsedMilliseconds);
                MakeTransaction(temptest4,connection);
                Console.WriteLine("Ending fourth task time elapsed till now...");

                Console.WriteLine(timer.ElapsedMilliseconds);
            } ,//close third Action
            
            () =>
              {
                Console.WriteLine("Begin fifth task time elapsed till now...");
                Console.WriteLine(timer.ElapsedMilliseconds);
                MakeTransaction(temptest5,connection);
                Console.WriteLine("Ending fifth task time elapsed till now...");

                Console.WriteLine(timer.ElapsedMilliseconds);
            } , //close third Action
            () =>
            {
                Console.WriteLine("Begin sixth task time elapsed till now...");
                Console.WriteLine(timer.ElapsedMilliseconds);
                MakeTransaction(temptest6,connection);
                Console.WriteLine("Ending sixth task time elapsed till now...");

                Console.WriteLine(timer.ElapsedMilliseconds);
            } 

                         ); //close parallel.invoke
                       
            connection.Close();

            long endTimer = timer.ElapsedMilliseconds;

            long totaltimeElapsed = endTimer - startTimer;

            timer.Stop();

            Console.WriteLine("Total Time taken  to insert 7 millions records in seconds"  + totaltimeElapsed/10000);
            Console.ReadLine();










        }


        private static void MakeTransaction(List<TempData> temps , SqlConnection connection)
        {
            
            ObjectReader reader = null;
            
            var dt = new DataTable();
            dt.Columns.Add("TestValueID", typeof(System.Guid));
            dt.Columns.Add("TestValueData", typeof(System.Decimal));
            dt.Columns.Add("CreatedBy", typeof(System.String));

            
            using (reader = ObjectReader.Create(temps))
            {
                dt.Load(reader);
            }

            DumpData(dt, connection);

          
        }




        static void Main(string[] args)
        {

            InsertBIGDATA();
                    
            // Now test for parallel 


         
        }



        

    }
}
