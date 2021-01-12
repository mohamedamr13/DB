using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace Gucera
{
    public partial class ADViewNACourses : System.Web.UI.Page
    {
        DataTable AllNACourses = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            if (ViewState["Records"] == null)
            {
                AllNACourses.Columns.Add("Name");
                AllNACourses.Columns.Add("Credit Hours");
                AllNACourses.Columns.Add("Price");
                AllNACourses.Columns.Add("Content");
                ViewState["Records"] = AllNACourses;
            }

           
            SqlCommand Courses = new SqlCommand("AdminViewNonAcceptedCourses", conn);
            Courses.CommandType = CommandType.StoredProcedure;

           // Table Course = new Table();
           // TableRow tr = new TableRow();
           // TableCell name = new TableCell();
           // TableCell CreditHours = new TableCell();
           // TableCell Price = new TableCell();
           // TableCell Content = new TableCell();
            
           // name.Text = "Name";
           // CreditHours.Text = "Credit Hours";
           // Price.Text = "Price";
           // Content.Text = "Content";
          
           // tr.Cells.Add(name);
           // tr.Cells.Add(CreditHours);
           // tr.Cells.Add(Price);
           // tr.Cells.Add(Content);
            
           // Course.Rows.Add(tr);


            conn.Open();
            SqlDataReader rdr = Courses.ExecuteReader(CommandBehavior.CloseConnection);
            while (rdr.Read())
            {

          
                AllNACourses.Rows.Add(rdr.GetString(rdr.GetOrdinal("name")), rdr.GetInt32(rdr.GetOrdinal("CreditHours")), rdr.GetDecimal(rdr.GetOrdinal("price")), rdr.GetString(rdr.GetOrdinal("content")));

                
              //  TableRow c = new TableRow();
              //  TableCell cname = new TableCell();
              //  TableCell chrs = new TableCell();
              //  TableCell cPrice = new TableCell();
              //  TableCell cCon = new TableCell();
                
              //  cname.Text = rdr.GetString(rdr.GetOrdinal("name"));
              //  cname.Width = 100;
              //  chrs.Text = rdr.GetInt32(rdr.GetOrdinal("CreditHours")).ToString();
              //  chrs.Width = 100;
              //  cPrice.Text = rdr.GetDecimal(rdr.GetOrdinal("price")).ToString();
              //  cPrice.Width = 100;
              //  cCon.Text = rdr.GetString(rdr.GetOrdinal("content"));
              //  cCon.Width = 100;
                
              //  c.Cells.Add(cname);
              //  c.Cells.Add(chrs);
              //  c.Cells.Add(cPrice);
              //  c.Cells.Add(cCon);
                
             //   Course.Rows.Add(c);

            }
            // form1.Controls.Add(Course);

            NAcourseTable.DataSource = AllNACourses;
            NAcourseTable.DataBind();

        }
    }
}
  