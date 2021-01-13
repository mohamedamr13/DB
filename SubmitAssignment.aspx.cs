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
    public partial class SubmitAssignment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void SubmitAssign(object sender, EventArgs e)
        {
            try
            {
                String connStr = WebConfigurationManager.ConnectionStrings["Milestone3"].ToString();
                SqlConnection conn = new SqlConnection(connStr);

                String AssignmentType = AssignType.Text;
                int AssignmentNumber = Int16.Parse(AssignNum.Text);
                int StudentID = Int16.Parse(sid.Text);
                int CourseID = Int16.Parse(cid.Text);

                SqlCommand SubmitAssignProc = new SqlCommand("SubmitAssign", conn);
                SubmitAssignProc.CommandType = CommandType.StoredProcedure;

                SubmitAssignProc.Parameters.Add(new SqlParameter("@assignType", AssignmentType));
                SubmitAssignProc.Parameters.Add(new SqlParameter("@assignnumber", AssignmentNumber));
                SubmitAssignProc.Parameters.Add(new SqlParameter("@sid", StudentID));
                SubmitAssignProc.Parameters.Add(new SqlParameter("@cid", CourseID));

                SqlParameter returnParameter = SubmitAssignProc.Parameters.Add("@error", SqlDbType.VarChar, 50);
                returnParameter.Direction = ParameterDirection.Output;

                conn.Open();
                SubmitAssignProc.ExecuteNonQuery();
                conn.Close();

                string ret = SubmitAssignProc.Parameters["@error"].Value.ToString();
               
                if (ret == "not enrolled in course")
                {
                    
                    err.Text = "<p style='color:red'>" + "You are not enrolled in this course" + "</p>";
                }
                else
                {
                    err.Text = "<p style='color:green'>" + "Assignment submitted successfully" + "</p>";
                }
            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Something went wrong, please press ok and check error message')", true);
                if (AssignType.Text == "" || AssignNum.Text == "" || sid.Text == "" || cid.Text == "")
                {

                    err.Text = "<p style='color:red'>" + "Please fill in all the required fields" + "</p>";

                }

                else if (AssignType.Text != "quiz" && AssignType.Text != "exam" && AssignType.Text != "project")
                {

                    err.Text = "<p style='color:red'>" + "Please enter the correct assignment type" + "</p>";

                }

                else
                {
                    err.Text = "<p style='color:red'>" + "Assignment already submitted" + "</p>";
                }
            }

        }

    }
}