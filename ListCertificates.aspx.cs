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
    public partial class ListCertificates : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Certificates(object sender, EventArgs e)
        {
            try
            {
                String connStr = WebConfigurationManager.ConnectionStrings["Milestone3"].ToString();
                SqlConnection conn = new SqlConnection(connStr);

                int CourseID = Int16.Parse(cid.Text);
                int StudentID = Int16.Parse(sid.Text);

                SqlCommand CertificateProc = new SqlCommand("viewCertificate", conn);
                CertificateProc.CommandType = CommandType.StoredProcedure;

                CertificateProc.Parameters.Add(new SqlParameter("@sid", StudentID));
                CertificateProc.Parameters.Add(new SqlParameter("@cid", CourseID));

                SqlParameter res = CertificateProc.Parameters.Add("@result", SqlDbType.VarChar, 60);
                res.Direction = ParameterDirection.Output;

                conn.Open();
                CertificateProc.ExecuteNonQuery();
                conn.Close();

                string error = CertificateProc.Parameters["@result"].Value.ToString();
                conn.Open();

                if (error == "student not enrolled in course or did not finish course")
                {
                    details.Text = "";
                    err.Text = "<p style='color:red'>" + "You are not enrolled in this course or you haven't finished it yet" + "</p>";
                }

                else
                {
                    err.Text = "";
                    SqlDataReader rdr = CertificateProc.ExecuteReader(CommandBehavior.CloseConnection);
                    while (rdr.Read())
                    {
                        DateTime cert = rdr.GetDateTime(rdr.GetOrdinal("issueDate"));
                        Label certify = new Label();
                        details.Text = "This student with a Student ID: " + sid.Text + " has earned a certificate for the course with a Course ID: " + cid.Text + " and its issue date is: " + cert.ToString();
                        form1.Controls.Add(certify);
                    }
                }

                conn.Close();
            }
            catch (Exception)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Something went wrong, please press ok and check error message')", true);
                if (sid.Text == "" || cid.Text == "")
                {
                    details.Text = "";
                    err.Text = "<p style='color:red'>" + "Please fill in all the required fields" + "</p>";

                }

            }
        }
    }
}