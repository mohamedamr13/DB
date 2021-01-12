using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Gucera
{
    public partial class ADViewCourses : System.Web.UI.Page
    {
        DataTable AllCourses = new DataTable();
        
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            AllCourses.Columns.Add("Name");
            AllCourses.Columns.Add("Credit Hours");
            AllCourses.Columns.Add("Price");
            AllCourses.Columns.Add("Content");
            AllCourses.Columns.Add("Accepted");


            
            SqlCommand Courses = new SqlCommand("AdminViewAllCourses", conn);
            Courses.CommandType = CommandType.StoredProcedure;
         //   Table Course = new Table();
         //   TableRow tr = new TableRow();
         //   TableCell name = new TableCell();
         //   TableCell CreditHours = new TableCell();
         //   TableCell Price = new TableCell();
         //   TableCell Content = new TableCell();
         //   TableCell accepted = new TableCell();
          //  name.Text = "Name";
          //  CreditHours.Text = "Credit Hours";
          //  Price.Text = "Price";
         //   Content.Text = "Content";
         //   accepted.Text = "Accepted";
         //   tr.Cells.Add(name);
        //    tr.Cells.Add(CreditHours);
         //   tr.Cells.Add(Price);
         //   tr.Cells.Add(Content);
         //   tr.Cells.Add(accepted);
         //   Course.Rows.Add(tr);

            conn.Open();
            SqlDataReader rdr = Courses.ExecuteReader(CommandBehavior.CloseConnection);

            while (rdr.Read())
            {
               if (!(rdr.GetOrdinal("accepted").Equals(null)))
                {
                    AllCourses.Rows.Add(rdr.GetString(rdr.GetOrdinal("name")), rdr.GetInt32(rdr.GetOrdinal("CreditHours")), rdr.GetDecimal(rdr.GetOrdinal("price")), rdr.GetString(rdr.GetOrdinal("content")), rdr.GetBoolean(rdr.GetOrdinal("accepted")));
                }

                else
               {
                    AllCourses.Rows.Add(rdr.GetString(rdr.GetOrdinal("name")), rdr.GetInt32(rdr.GetOrdinal("CreditHours")), rdr.GetDecimal(rdr.GetOrdinal("price")), rdr.GetString(rdr.GetOrdinal("content")));

                }




                //  TableRow c = new TableRow();
                //  TableCell cname = new TableCell();
                //     TableCell chrs = new TableCell();
                //     TableCell cPrice = new TableCell();
                //     TableCell cCon = new TableCell();
                //      TableCell caccepted = new TableCell();
                //     cname.Text = rdr.GetString(rdr.GetOrdinal("name"));
                //     cname.Width = 100;
                //    chrs.Text = rdr.GetInt32(rdr.GetOrdinal("CreditHours")).ToString();
                //    chrs.Width = 100;
                //    cPrice.Text = rdr.GetDecimal(rdr.GetOrdinal("price")).ToString();
                //   cPrice.Width = 100;
                //     cCon.Text = rdr.GetString(rdr.GetOrdinal("content"));
                //    cCon.Width = 100;
                //    if (rdr.GetOrdinal("accepted").Equals(null))
                //    {
                //      caccepted.Text = "Null";
                //}
                //  else
                //  {

                //     caccepted.Text = rdr.GetBoolean(rdr.GetOrdinal("accepted")).ToString();

                //}
                // caccepted.Width = 100;
                // c.Cells.Add(cname);
                // c.Cells.Add(chrs);
                // c.Cells.Add(cPrice);
                // c.Cells.Add(cCon);
                // c.Cells.Add(caccepted);
                // Course.Rows.Add(c);







            }
            courseTable.DataSource = AllCourses;
            courseTable.DataBind();

 //           form1.Controls.Add(Course);
            
        }
    }
}
