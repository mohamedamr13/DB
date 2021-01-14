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
    public partial class SubmitAssignment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void SubmitAssign(object sender, EventArgs e)
        {
            try
            {
                String connStr = WebConfigurationManager.ConnectionStrings["guc"].ToString();  //should be guc
                SqlConnection conn = new SqlConnection(connStr);

                String AssignmentType = AssignType.Text;
                int AssignmentNumber = Int16.Parse(AssignNum.Text);
                int CourseID = Int16.Parse(cid.Text);
                int stu_id = (int)Session["user"];



                SqlCommand SubmitAssignProc = new SqlCommand("SubmitAssign", conn);
                SubmitAssignProc.CommandType = CommandType.StoredProcedure;

                SubmitAssignProc.Parameters.Add(new SqlParameter("@assignType", AssignmentType));
                SubmitAssignProc.Parameters.Add(new SqlParameter("@assignnumber", AssignmentNumber));
                SubmitAssignProc.Parameters.Add(new SqlParameter("@sid", stu_id));
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
            catch (Exception ex )
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Something went wrong, please press ok and check error message')", true);
                if (AssignType.Text == "" || AssignNum.Text == "" || cid.Text == "")
                {

                    err.Text = "<p style='color:red'>" + "Please fill in all the required fields" + "</p>";

                }

                else if (AssignType.Text != "quiz" && AssignType.Text != "exam" && AssignType.Text != "project")
                {

                    err.Text = "<p style='color:red'>" + "Please enter the correct assignment type" + "</p>";

                }

                else if (ex.Message.Contains("Cannot insert duplicate key"))
                {

                    err.Text = "<p style='color:red'>" + "Assignment already submitted" + "</p>";
                    

                }
                else {

                    err.Text = "<p style='color:red'>" + "This assignment does not exist" + "</p>";

                }
            }

        }

    }
}