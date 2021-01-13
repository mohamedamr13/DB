using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Milestone3
{
    public partial class AddFeedback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Feedback(object sender, EventArgs e)
        {
            try
            {
                String connStr = WebConfigurationManager.ConnectionStrings["Milestone3"].ToString();
                SqlConnection conn = new SqlConnection(connStr);

                String Comment = comt.Text;
                int CourseID = Int16.Parse(cid.Text);
                int StudentID = Int16.Parse(sid.Text);

                SqlCommand AddFeedbackProc = new SqlCommand("addFeedback", conn);
                AddFeedbackProc.CommandType = CommandType.StoredProcedure;

                AddFeedbackProc.Parameters.Add(new SqlParameter("@comment", Comment));
                AddFeedbackProc.Parameters.Add(new SqlParameter("@cid", CourseID));
                AddFeedbackProc.Parameters.Add(new SqlParameter("@sid", StudentID));

                

                conn.Open();
                AddFeedbackProc.BeginExecuteNonQuery();
                conn.Close();

                SqlParameter error = AddFeedbackProc.Parameters.Add("@false", SqlDbType.VarChar, 50);
                error.Direction = ParameterDirection.Output;

                string ret = AddFeedbackProc.Parameters["@false"].Value.ToString();


                if (ret == "student not enrolled in course")
                {
                    succ.Text = "";
                    err.Text = "<p style='color:red'>" + "You are not enrolled in this course" + "</p>";

                }
                else
                {
                    err.Text = "";
                    succ.Text = "<p style='color:green'>" + "Feedback has been added successfully" + "</p>";
                }
            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Something went wrong, please press ok and check error message')", true);
                if (comt.Text == "" || sid.Text == "" || cid.Text == "")
                {
                    succ.Text = "";
                    err.Text = "<p style='color:red'>" + "Please fill in all the required fields" + "</p>";

                }

             }


        }

    }
}