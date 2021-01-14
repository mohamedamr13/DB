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

            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand feedback = new SqlCommand("ViewFeedbacksAddedByStudentsOnMyCourse", conn);
            feedback.CommandType = CommandType.StoredProcedure;
            int insId = (int)Session["user"];

            int cid = (int)Session["course"];


            feedback.Parameters.Add(new SqlParameter("@instrId", insId));
            feedback.Parameters.Add(new SqlParameter("@cid", cid));




            conn.Open();
            SqlDataReader rdr = feedback.ExecuteReader(CommandBehavior.CloseConnection);
            while (rdr.Read())
            {
                String comment = rdr.GetString(rdr.GetOrdinal("comment"));

                int num = rdr.GetInt32(rdr.GetOrdinal("number"));


                int likes = rdr.GetInt32(rdr.GetOrdinal("numberOfLikes"));



                TableRow row = new TableRow();
                ///////////  create new row
                TableCell feed = new TableCell();
                feed.Text = num.ToString();

                TableCell like = new TableCell();
                like.Text = likes.ToString();

                TableCell comm = new TableCell();
                comm.Text = comment;


                row.Cells.Add(feed);
                row.Cells.Add(like);
                row.Cells.Add(comm);
                f1.Rows.Add(row);



            }
        }

        public void bCourses(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            Response.Redirect("Course.aspx");
        }


    }
}