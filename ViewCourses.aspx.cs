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
    public partial class ViewCourses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand courses = new SqlCommand("InstructorViewAcceptedCoursesByAdmin",conn);
            courses.CommandType = CommandType.StoredProcedure;
            int insId = (int)Session["user"];
            courses.Parameters.Add(new SqlParameter("@instrId", insId));



            conn.Open();
            SqlDataReader rdr = courses.ExecuteReader(CommandBehavior.CloseConnection);
            while (rdr.Read())
            {
                String courseName = rdr.GetString(rdr.GetOrdinal("name"));
                int id = rdr.GetInt32(rdr.GetOrdinal("id"));
                Button course = new Button();
                course.Click += new EventHandler(this.goToCourse);
                course.ID = id.ToString();
                course.Text = " Course Name : " +  courseName +  " ,  Course Id : " +   id;

                //course.Attributes.Add("onClick", "goToCourse");
                form1.Controls.Add(course);
                Literal l = new Literal();
                l.Text = " <br /> <br /> <br />";

                form1.Controls.Add(l);

            }
            


        }

        protected void goToCourse(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            Button b = (Button)sender;

            Session["course"] = Int32.Parse (b.ID);
            Response.Redirect("Course.aspx");
        }

        protected void dash(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            Response.Redirect("instrHome.aspx");
        }




    }
}