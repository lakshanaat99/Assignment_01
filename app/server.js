const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;


const STUDENT_NAME_and_SID = "A.A.T.Lakshan_22UG1-0309";

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AWS Fargate Deployment</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                color: white;
            }
            .container {
                text-align: center;
                background: rgba(255, 255, 255, 0.1);
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
                backdrop-filter: blur(4px);
                border: 1px solid rgba(255, 255, 255, 0.18);
                max-width: 600px;
            }
            h1 {
                margin-bottom: 20px;
                font-size: 2.5em;
            }
            .info {
                background: rgba(255, 255, 255, 0.2);
                padding: 20px;
                border-radius: 10px;
                margin: 20px 0;
            }
            .status {
                display: inline-block;
                background: #4CAF50;
                padding: 10px 20px;
                border-radius: 25px;
                margin: 10px;
                font-weight: bold;
            }
            .details {
                text-align: left;
                margin-top: 20px;
            }
            .details p {
                margin: 10px 0;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>AWS ECS Fargate</h1>
            <div class="status">Application Running Successfully</div>
            <div class="info">
                <h2>Deployment Information</h2>
                <div class="details">
                    <p><strong>Student Name:</strong> ${STUDENT_NAME}</p>
                    <p><strong>Service:</strong> Node.js Application on ECS Fargate</p>
                    <p><strong>Port:</strong> ${PORT}</p>
                    <p><strong>Environment:</strong> ${process.env.NODE_ENV || 'production'}</p>
                    <p><strong>Uptime:</strong> ${Math.floor(process.uptime())} seconds</p>
                    <p><strong>Health Check:</strong> <a href="/health" style="color: #FFD700;">/health</a></p>
                </div>
            </div>
            <p style="margin-top: 30px; font-size: 0.9em; opacity: 0.8;">
                Powered by AWS ECS Fargate | Terraform | GitHub Actions
            </p>
        </div>
    </body>
    </html>
  `);
});

// API endpoint example
app.get('/api/info', (req, res) => {
  res.json({
    message: 'Welcome to AWS Fargate API',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      info: '/api/info',
      root: '/'
    }
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Health check available at http://localhost:${PORT}/health`);
});
