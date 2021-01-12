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
    public partial class viewFeedback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }


        protected void getFeedback(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand feedback = new SqlCommand("InstructorViewAcceptedCoursesByAdmin", conn);
            feedback.CommandType = CommandType.StoredProcedure;
            int insId = (int)Session["user"];

            int cid = Int32.Parse(cc.Text);
            

            feedback.Parameters.Add(new SqlParameter("@insId", insId));
            feedback.Parameters.Add(new SqlParameter("@cid", cid));




            conn.Open();
            SqlDataReader rdr = feedback.ExecuteReader(CommandBehavior.CloseConnection);
            while (rdr.Read())
            {
                String comment = rdr.GetString(rdr.GetOrdinal("comment"));

                int num = rdr.GetInt32(rdr.GetOrdinal("number"));
                int likes = rdr.GetInt32(rdr.GetOrdinal("numberOfLikes"));

                Button f = new Button();
                f.ID = "ff";

                f.Text = " Comment Number : " + num + " ,  Comment : " + comment +  " Likes : " + likes;

                //course.Attributes.Add("onClick", "goToCourse");
                form1.Controls.Add(f);
                Literal l = new Literal();
                l.Text = "<br />";
                form1.Controls.Add(l);

            }
        }

    }
}