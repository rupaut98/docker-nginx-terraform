using Microsoft.AspNetCore.Mvc;
using docker_nginx_terraform.Models;
using System.Collections.Generic;
using System.Linq;
using docker_nginx_terraform.Contexts;
using TaskModel = docker_nginx_terraform.Models.Task;

namespace docker_nginx_terraform.Controllers
{
    [ApiController]
    [Route("api/[controller]")]

    public class TaskController : ControllerBase{

        protected readonly ApplicationDbContext _context;

        public TaskController(ApplicationDbContext context){
            _context = context;
        }

        [HttpGet("get")]

        public ActionResult<IEnumerable<TaskModel>> GetTasks(){
            return Ok(_context.Tasks.ToList());
        }

        // GET: api/task/{id}
        [HttpGet("get/{id}")]
        public ActionResult<TaskModel> GetTaskById(int id){

            var task = _context.Tasks.Find(id);

            if (task == null){
                return NotFound();
            }

            return Ok(task);
        }

        //POST: api/task/create
        [HttpPost("create")]
        public ActionResult<TaskModel> CreateTask(TaskModel newTask){
            _context.Tasks.Add(newTask);
            _context.SaveChanges();

            return CreatedAtAction(nameof(GetTaskById), new {id = newTask.Id}, newTask);
        }

        [HttpDelete("delete/{id}")]
        public ActionResult<TaskModel> DeleteTaskById(int id){
            var task = _context.Tasks.Find(id);

            if (task == null){
                return NotFound();
            }
            else{
                _context.Tasks.Remove(task);
                _context.SaveChanges();

                return NoContent();
            }
        }

    }

    public class ExtendedTaskController : TaskController
    {
        public ExtendedTaskController(ApplicationDbContext context) : base(context)
        {
        }
        [HttpGet]
        public ActionResult<List<TaskModel>> GetCompletedTasks(){
            var completedTasks = _context.Tasks.Where(t => t.IsCompleted==true).ToList();

            return Ok(completedTasks);
        }

        [HttpPost]
        public ActionResult<TaskModel> ModifyDescriptionById(int id, string d){
            var task = _context.Tasks.Find(id);

            if (task == null){
                return NotFound();
            }

            task.Description = d;
            _context.SaveChanges();

            return Ok(task);
        }
    }
}