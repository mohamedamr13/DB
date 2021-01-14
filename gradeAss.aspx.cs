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
    public partial class gradeAss : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        protected void gradeAssign(object sender, EventArgs e)
        {

            String connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

           try
            {

                int id = ((int)Session["user"]);

                int Cid = ((int)Session["course"]);
                int Sid = Int32.Parse(sid.Text);

                int num = Int32.Parse(number.Text);
                string typ = type.Text;
                int gr = Int32.Parse(grade.Text);


                SqlCommand proc = new SqlCommand("InstructorgradeAssignmentOfAStudent", conn);

                proc.CommandType = CommandType.StoredProcedure;


                proc.Parameters.Add(new SqlParameter("@instrId", id));
                proc.Parameters.Add(new SqlParameter("@cid", Cid));
                proc.Parameters.Add(new SqlParameter("@assignmentNumber", num));
                proc.Parameters.Add(new SqlParameter("@type", typ));
                proc.Parameters.Add(new SqlParameter("@grade", gr));
                proc.Parameters.Add(new SqlParameter("@sid", Sid));

                conn.Open();
                proc.ExecuteNonQuery();
                conn.Close();

                Response.Write("Assignment Graded");

        }
           catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Please enter all required data correctly')", true);
        }




    }
        protected void dash(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            Response.Redirect("Course.aspx");
        }
    }
}