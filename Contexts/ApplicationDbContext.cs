using Microsoft.EntityFrameworkCore;
using docker_nginx_terraform.Models;
using TaskModel = docker_nginx_terraform.Models.Task;

namespace docker_nginx_terraform.Contexts
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<TaskModel> Tasks { get; set; }

    }
}