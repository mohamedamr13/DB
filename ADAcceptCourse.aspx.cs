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
    public partial class ADAcceptCourse : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            SqlCommand Courses = new SqlCommand("select id,name from Course where accepted=0 or accepted is null ", conn);
            Courses.CommandType = CommandType.Text;
            conn.Open();
            SqlDataReader rdr = Courses.ExecuteReader(CommandBehavior.CloseConnection);
            while (rdr.Read())
            {
                ListItem l = new ListItem();
                l.Text = rdr.GetInt32(rdr.GetOrdinal("id")).ToString() + " "+rdr.GetString(rdr.GetOrdinal("name"));
                NonAccepted.Items.Add(l);
            }
        }
        protected void nonAcceptedClick(object sender, EventArgs e)
        {
            try
            {
                string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
                SqlConnection conn = new SqlConnection(connStr);
                SqlCommand CoursesProc = new SqlCommand("AdminAcceptRejectCourse", conn);
                CoursesProc.CommandType = CommandType.StoredProcedure;
                CoursesProc.Parameters.Add(new SqlParameter("@adminid", Session["user"]));
                CoursesProc.Parameters.Add(new SqlParameter("@courseId", NonAccepted.SelectedValue.ElementAt(0)));
                Label l = new Label();
                conn.Open();
                CoursesProc.ExecuteNonQuery();
                conn.Close();
                Response.Redirect("AdminHome.aspx");

           }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('please choose a course to accept')", true);

            }
        }
    }
}