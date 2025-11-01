using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MVCDemoC.Models;

namespace MVCDemoC.Controllers
{
    public class invoicesController : Controller
    {
        private InvoicesDBEntities db = new InvoicesDBEntities();

        // GET: invoices
        public ActionResult Index()
        {
            var invoices = db.invoices.Include(i => i.customers).Where(x => x.active == true);
            return View(invoices.ToList());
        }

        // GET: invoices/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            invoices invoices = db.invoices.Find(id);
            if (invoices == null)
            {
                return HttpNotFound();
            }
            return View(invoices);
        }

        // GET: invoices/Create
        public ActionResult Create()
        {
            ViewBag.customer_id = new SelectList(db.customers.Where(x => x.active == true), "customer_id", "name");
            return View();
        }

        // POST: invoices/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "invoice_id,customer_id,date,total,active")] invoices invoices)
        {
            if (ModelState.IsValid)
            {
                invoices.active = true;
                db.invoices.Add(invoices);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.customer_id = new SelectList(db.customers.Where(x => x.active == true), "customer_id", "name", invoices.customer_id);
            return View(invoices);
        }

        // GET: invoices/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            invoices invoices = db.invoices.Find(id);
            if (invoices == null)
            {
                return HttpNotFound();
            }
            ViewBag.customer_id = new SelectList(db.customers.Where(x => x.active == true), "customer_id", "name", invoices.customer_id);
            return View(invoices);
        }

        // POST: invoices/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "invoice_id,customer_id,date,total,active")] invoices invoices)
        {
            if (ModelState.IsValid)
            {
                db.Entry(invoices).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.customer_id = new SelectList(db.customers.Where(x => x.active == true), "customer_id", "name", invoices.customer_id);
            return View(invoices);
        }

        // GET: invoices/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            invoices invoices = db.invoices.Find(id);
            if (invoices == null)
            {
                return HttpNotFound();
            }
            return View(invoices);
        }

        // POST: invoices/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            invoices invoices = db.invoices.Find(id);
            // Eliminación lógica: solo cambiar active a false
            invoices.active = false;
            db.Entry(invoices).State = EntityState.Modified;
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
