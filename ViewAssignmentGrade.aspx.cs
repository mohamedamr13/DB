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
    public partial class ViewAssignmentGrade : System.Web.UI.Page
    {
        public object ViewAssignContentProc { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ViewAssignGrade(object sender, EventArgs e)
        {
            try
            {

                String connStr = WebConfigurationManager.ConnectionStrings["Milestone3"].ToString();
                SqlConnection conn = new SqlConnection(connStr);

                int AssignmentNumber = Int16.Parse(AssignNum.Text);
                String AssignmentType = AssignType.Text;
                int CourseID = Int16.Parse(cid.Text);
                int StudentID = Int16.Parse(sid.Text);


                SqlCommand ViewAssignGradeProc = new SqlCommand("viewAssignGrades", conn);
                ViewAssignGradeProc.CommandType = CommandType.StoredProcedure;

                ViewAssignGradeProc.Parameters.Add(new SqlParameter("@assignnumber", AssignmentNumber));
                ViewAssignGradeProc.Parameters.Add(new SqlParameter("@assignType", AssignmentType));
                ViewAssignGradeProc.Parameters.Add(new SqlParameter("@cid", CourseID));
                ViewAssignGradeProc.Parameters.Add(new SqlParameter("@sid", StudentID));

                SqlParameter grade = ViewAssignGradeProc.Parameters.Add("@assignGrade", SqlDbType.Int);
                grade.Direction = ParameterDirection.Output;

                SqlParameter error = ViewAssignGradeProc.Parameters.Add("@error", SqlDbType.Int);
                error.Direction = ParameterDirection.Output;

                conn.Open();
                ViewAssignGradeProc.ExecuteNonQuery();
                conn.Close();

                string retError = ViewAssignGradeProc.Parameters["@error"].Value.ToString();
                int retGrade = (int)ViewAssignGradeProc.Parameters["@assignGrade"].Value;
                string value = retGrade.ToString();

                if (retError == "user does not take course")
                {
                    grd.Text = "";
                    err.Text = "<p style='color:red'>" + "You are not enrolled in this course" + "</p>";

                }

                else if (value == "")
                {
                    grd.Text = "";
                    err.Text = "<p style='color:red'>" + "Assignment grade not updated yet" + "</p>";
                }

                else
                {
                    err.Text = "";
                    grd.Text = "Your grade for this assignment is: " + value;
                }
            }
            catch (ArgumentNullException)
            {
                grd.Text = "";
                err.Text = "<p style='color:red'>" + "Assignment grade not updated yet" + "</p>";
            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Something went wrong, please press ok and check error message')", true);
                if (AssignType.Text == "" || AssignNum.Text == "" || sid.Text == "" || cid.Text == "")
                {
                    grd.Text = "";
                    err.Text = "<p style='color:red'>" + "Please fill in all the required fields" + "</p>";

                }

                else if (AssignType.Text != "quiz" && AssignType.Text != "exam" && AssignType.Text != "project")
                {
                    grd.Text = "";
                    err.Text = "<p style='color:red'>" + "Please enter the correct assignment type" + "</p>";

                }

                else
                {
                    grd.Text = "";
                    err.Text = "<p style='color:red'>" + "This assignment does not exist" + "</p>";
                  }

            }






        }
    }
}