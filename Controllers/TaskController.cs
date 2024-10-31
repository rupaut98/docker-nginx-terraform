using Microsoft.AspNetCore.Mvc;
using docker_nginx_terraform.Models;
using System.Collections.Generic;
using System.Linq;
using TaskModel = docker_nginx_terraform.Models.Task;

namespace docker_nginx_terraform.Controllers
{
    [ApiController]
    [Route("api/[controller]")]

    public class TaskController : ControllerBase{

        protected static List<TaskModel> tasks = new List<TaskModel>();

        [HttpGet("get")]

        public ActionResult<IEnumerable<TaskModel>> GetTasks(){
            return Ok(tasks);
        }

        // GET: api/task/{id}
        [HttpGet("get/{id}")]
        public ActionResult<TaskModel> GetTaskById(int id){
            TaskModel task = null;

            foreach (var t in tasks){
                if (t.Id == id){
                    task = t;
                    break;
                }
            }

            if (task == null){
                return NotFound();
            }

            return Ok(task);
        }

        //POST: api/task/create
        [HttpPost("create")]
        public ActionResult<TaskModel> CreateTask(TaskModel newTask){
            
            if (tasks.Count > 0){
                int MaxId = tasks.Max(t => t.Id);
                newTask.Id = MaxId + 1;
            }
            else{
                newTask.Id = 1;
            }
            tasks.Add(newTask);
            return CreatedAtAction(nameof(GetTaskById), new {id = newTask.Id}, newTask);
        }

        [HttpDelete("delete/{id}")]
        public ActionResult<TaskModel> DeleteTaskById(int id){
            TaskModel task = null;

            foreach (var t in tasks){
                if (t.Id == id){
                    task = t;
                    break;
                }
            }

            if (task == null){
                return NotFound();
            }
            else{
                tasks.Remove(task);

                return NoContent();
            }
        }

    }

    public class ExtendedTaskController : TaskController
    {
        [HttpGet]
        public ActionResult<List<TaskModel>> GetCompletedTasks(){
            List<TaskModel> completedTasks = new List<TaskModel>();

            foreach (var t in tasks){
                if (t.IsCompleted == true){
                    completedTasks.Add(t);
                }
            }

            return Ok(completedTasks);
        }

        [HttpPost]
        public ActionResult<TaskModel> ModifyDescriptionById(int id, string d){
            TaskModel task = null;

            foreach (var t in tasks){
                if (t.Id == id){
                    task = t;
                    task.Description = d;
                    break;
                }
            }
            if (task == null){
                return NotFound();
            }

            return Ok(task);
        }
    }
}