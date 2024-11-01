using Microsoft.EntityFrameworkCore;
using docker_nginx_terraform.Models;

namespace docker_nginx_terraform.Contexts
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<Task> Tasks { get; set; }

    }
}