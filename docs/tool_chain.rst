Toolchain
=========

These are the sets of tools that are used by Teraciers to create products. All Teraciers must master
these tools.

Git
---


Vim
---

Sublime Text
------------

Jira Client
-----------
This section shows you how to use Jira Client to manage your Teracy issues.

Downloading and Installation
````````````````````````````
Download Jira Client installer for Mac, Linux, Win at http://almworks.com/jiraclient/download.html
and install on your local device.

Creating connection
````````````````````

1. Open Jira Client and select **Connection** --> **New Jira Connection** to open the **New Jira Connection**
form.
 
  .. image:: _static/Toolchain/new-jira-connection.png
     :align: center

2. Input the Jira URL of Teracy ``https://issues.teracy.org`` into the **URL** field.

  .. image:: _static/Toolchain/new-jira-connection-form.png
     :align: center

3. Input your username and password used to log in Jira.

4. Click **Next** to verify your login and select projects you work with.

  .. image:: _static/Toolchain/select-projects.png
     :align: center

5. Click **Next** to name your connection and click **Finish** to complete creating your Jira connection.

Creating queries
````````````````

You need to create some queries to manage your issues easily. At Teracy, you are recommended to create queries with
the hiearachy as the example follows:

 .. image:: _static/Toolchain/structure-of-queries.png
    :align: center


**1. Creating new query by Sprint**

Right-click your connection name --> Select **New Query** --> Select **Sprint** in the
**Field** column and select your desired sprint in the  **Sprint** column --> click **OK**.

.. image:: _static/Toolchain/query-by-sprint.png
   :align: center

.. note::
 For each sprint, you should create a query for it.

**2. Creating new query by status**

You need to create three queries by status for each sprint: **Open/Reopened**, **In-progress** and **Resolved**.

- **Open, Re-opened**

  Right-click a query by sprint --> Select **New Query** --> Select **Status** in the **Field** column
  --> Select **Open** and **Re-open** --> Click **OK**.

- **In-progess**: Do the same as **Open, Re-opened**.

- **Resolved**: Do the same as **Open, Re-opened**.

**3.  Creating new query by assignee**

For each status, you will create a query by assignee as follows:

- Right-click a status --> **New Query** --> Select **Assignee** in the **Field** column
  --> Select a assignee in the **Assignee** column --> Click **OK**.

.. image:: _static/Toolchain/query-by-assignee.png
   :align: center

Editing and Removing queries
````````````````````````````

You can easily edit or delete a query by right-clicking the query and select **Edit Query** or **Remove** in the
context menu respectively.

.. image:: _static/Toolchain/edit-remove-query.png
   :align: center

Reloading query from server
```````````````````````````

Sometimes, you need to  reload all issues for a query by
right-clicking the query and selecting **Reload Query from Server** from the context menu.

Tracking time
``````````````

At Teracy, you are recommended to use the Jira Client to track off your working time for each issue every day.
Jira Client measures the exact time you've spent on the issue.

- **Starting tracking time**

  Select your issue you are working on and click the **Start** button to begin tracking time.
 
  .. image:: _static/Toolchain/start-button.png
     :align: center

- **Stopping tracking time**
  
  When you pause to work or finish your issue, you can stop tracking time by clicking the **Stop** button.
 
  .. image:: _static/Toolchain/stop-button.png
     :align: center

- **Switching to another issue**
 
  When switching to another issue and you want to record time spent on the issue, open issue and click the
  **Record** button.
 
  .. image:: _static/Toolchain/starting-tracking-time.png
     :align: center

- **Adjusting time and duration**

  You can also adjust time and duration by clicking the time recorded on the Time Tracker.
  
  .. image::  _static/Toolchain/edit-time.png
     :align: center 

Later, you can review the time sheet, make corrections and publish tracked time to JIRA as work logs. 

.. note::
  You can see further usage of Jira Client at http://almworks.com/jiraclient/features.html.