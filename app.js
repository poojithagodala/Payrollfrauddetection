document.getElementById('salaryForm').addEventListener('submit', function (e) {
  e.preventDefault();

  const empId = document.getElementById('empId').value;
  const amount = document.getElementById('amount').value;

  // Simulate insert & fraud detection
  const alertBox = document.getElementById('alerts');
  alertBox.innerHTML = `Submitted Salary: ${amount} for EMP_ID: ${empId} <br/> (Fraud check would be triggered)`;

  // Extend: fetch audit logs via backend
});
