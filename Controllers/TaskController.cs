using Microsoft.AspNetCore.Mvc;
using docker_nginx_terraform.Models;
using System.Collections.Generic;
using System.Linq;
using docker_nginx_terraform.Contexts;
using TaskModel = docker_nginx_terraform.Models.Task;
using System;

namespace docker_nginx_terraform.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TaskController : ControllerBase
    {
        protected readonly ApplicationDbContext _context;

        public TaskController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpGet("get")]
        public ActionResult<IEnumerable<TaskModel>> GetTasks()
        {
            try
            {
                var tasks = _context.Tasks.ToList();
                return Ok(tasks);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while retrieving tasks.", error = ex.Message });
            }
        }

        [HttpGet("get/{id}")]
        public ActionResult<TaskModel> GetTaskById(int id)
        {
            try
            {
                var task = _context.Tasks.Find(id);
                if (task == null)
                {
                    return NotFound(new { message = $"Task with ID {id} not found." });
                }
                return Ok(task);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while retrieving the task.", error = ex.Message });
            }
        }

        [HttpPost("create")]
        public ActionResult<TaskModel> CreateTask(TaskModel newTask)
        {
            try
            {
                _context.Tasks.Add(newTask);
                _context.SaveChanges();

                return CreatedAtAction(nameof(GetTaskById), new { id = newTask.Id }, newTask);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while creating the task.", error = ex.Message });
            }
        }

        [HttpDelete("delete/{id}")]
        public ActionResult<TaskModel> DeleteTaskById(int id)
        {
            try
            {
                var task = _context.Tasks.Find(id);

                if (task == null)
                {
                    return NotFound(new { message = $"Task with ID {id} not found." });
                }

                _context.Tasks.Remove(task);
                _context.SaveChanges();

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while deleting the task.", error = ex.Message });
            }
        }
    }

    public class ExtendedTaskController : TaskController
    {
        public ExtendedTaskController(ApplicationDbContext context) : base(context) { }

        [HttpGet("getCompletedTasks")]
        public ActionResult<List<TaskModel>> GetCompletedTasks()
        {
            try
            {
                var completedTasks = _context.Tasks.Where(t => t.IsCompleted).ToList();
                return Ok(completedTasks);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while retrieving completed tasks.", error = ex.Message });
            }
        }

        [HttpPost("modifyDescription/{id}")]
        public ActionResult<TaskModel> ModifyDescriptionById(int id, [FromBody] string description)
        {
            try
            {
                var task = _context.Tasks.Find(id);

                if (task == null)
                {
                    return NotFound(new { message = $"Task with ID {id} not found." });
                }

                task.Description = description;
                _context.SaveChanges();

                return Ok(task);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while modifying the task description.", error = ex.Message });
            }
        }
    }
}
