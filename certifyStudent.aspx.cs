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
    public partial class certifyStudent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void certify(object sender, EventArgs e)
        {

            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            int id = (int)Session["user"];
            int cc = (int)Session["course"];
           // try
            //{

                DateTime dt = DateTime.Parse(date.Text);
                int ss = Int32.Parse(sid.Text);
                SqlCommand checker = new SqlCommand("select grade  from StudentTakeCourse where sid =" + ss + "and cid=" + cc , conn);
                checker.CommandType = CommandType.Text;
                conn.Open();
                SqlDataReader rdr = checker.ExecuteReader(CommandBehavior.CloseConnection);
            float check = 0;
                while (rdr.Read())
                {
                try
                {
                     check = (float)rdr.GetDecimal(rdr.GetOrdinal("grade"));
                }
                catch (System.Data.SqlTypes.SqlNullValueException)
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('This student still hasn't recieved a grade in this course')", true);
                    Response.Write("This student still hasn't recieved a grade in  this course"  );
                    //return;
                }
               
                    if (check <= 2.0)
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('You can only issue a certificate to a student with a grade greater than 2.0 in this course')", true);
                        return;

                    }
                
                }
                conn.Close();


                SqlCommand cert = new SqlCommand("InstructorIssueCertificateToStudent", conn);
                cert.CommandType = CommandType.StoredProcedure;


                cert.Parameters.Add(new SqlParameter("@cid", cc));
                cert.Parameters.Add(new SqlParameter("@sid", ss));
                cert.Parameters.Add(new SqlParameter("@insId", id));
                cert.Parameters.Add(new SqlParameter("@issueDate", dt));

                conn.Open();
                cert.ExecuteNonQuery();
                conn.Close();

                Response.Write("Student certified");
            //}
            //catch (Exception)
            //{
              //  ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Please enter all required data correctly')", true);
            //}


        }
        protected void dash(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            Response.Redirect("Course.aspx");
        }
    }
}