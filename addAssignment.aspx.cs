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
    public partial class addAssignment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void submit(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            int id =  ((int) Session["user"]);
            int cid = ((int)Session["course"]);
            try
            {
                int Cid = cid;
                int num = Int32.Parse(number.Text);
                string typ = type.Text;
                int grade = Int32.Parse(fullGrade.Text);

                int weigh = Int32.Parse(weight.Text);
                DateTime dt = DateTime.Parse(deadline.Text);
                string cnt = content.Text;
                if (!checkLength(cnt, 200))
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Maxiumum Content length is 200')", true);

                else
                {

                    SqlCommand proc = new SqlCommand("DefineAssignmentOfCourseOfCertianType", conn);

                    proc.CommandType = CommandType.StoredProcedure;


                    proc.Parameters.Add(new SqlParameter("@instId", id));
                    proc.Parameters.Add(new SqlParameter("@cid", Cid));
                    proc.Parameters.Add(new SqlParameter("@number", num));
                    proc.Parameters.Add(new SqlParameter("@type", typ));
                    proc.Parameters.Add(new SqlParameter("@fullGrade", grade));
                    proc.Parameters.Add(new SqlParameter("@weight", weigh));
                    proc.Parameters.Add(new SqlParameter("@deadline", dt));
                    proc.Parameters.Add(new SqlParameter("@content", cnt));

                    conn.Open();
                    proc.ExecuteNonQuery();
                    conn.Close();

                    Response.Write("New Assignment Added");

                }
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
        public Boolean checkLength(String s, int n)
        {
            if (s.Length <= n)
                return true;
            else
                return false;
        }
    }
}