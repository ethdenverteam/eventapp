#!/bin/bash

# EventApp Deployment Script
# This script automates the deployment process for EventApp

set -e  # Exit on any error

echo "🚀 Starting EventApp deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_dependencies() {
    print_status "Checking dependencies..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 18+ first."
        exit 1
    fi
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install npm first."
        exit 1
    fi
    
    # Check Git
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    # Check Railway CLI
    if ! command -v railway &> /dev/null; then
        print_warning "Railway CLI is not installed. Installing now..."
        npm install -g @railway/cli
    fi
    
    print_success "All dependencies are available"
}

# Build frontend
build_frontend() {
    print_status "Building frontend..."
    
    cd frontend
    
    # Install dependencies
    print_status "Installing frontend dependencies..."
    npm install
    
    # Build the application
    print_status "Building Next.js application..."
    npm run build
    
    print_success "Frontend built successfully"
    cd ..
}

# Deploy frontend to Vercel
deploy_frontend() {
    print_status "Deploying frontend to Vercel..."
    
    cd frontend
    
    # Check if Vercel is configured
    if [ ! -f ".vercel/project.json" ]; then
        print_warning "Vercel not configured. Please run 'vercel' first to configure."
        print_status "You can deploy manually by:"
        print_status "1. Go to https://vercel.com"
        print_status "2. Import your GitHub repository"
        print_status "3. Set root directory to 'frontend'"
        print_status "4. Deploy"
    else
        print_status "Deploying to Vercel..."
        vercel --prod
    fi
    
    cd ..
}

# Deploy backend to Railway
deploy_backend() {
    print_status "Deploying backend to Railway..."
    
    cd backend
    
    # Check if Railway is configured
    if [ ! -f ".railway/project.json" ]; then
        print_warning "Railway not configured. Initializing..."
        railway init
    fi
    
    # Deploy
    print_status "Deploying to Railway..."
    railway up
    
    cd ..
}

# Setup database
setup_database() {
    print_status "Setting up database..."
    
    print_status "Please follow these steps to set up Supabase:"
    print_status "1. Go to https://supabase.com"
    print_status "2. Create a new project"
    print_status "3. Wait for project to be ready"
    print_status "4. Go to SQL Editor"
    print_status "5. Run the SQL script from database/schema.sql"
    print_status "6. Copy the database connection string"
    print_status "7. Add it to Railway environment variables as DATABASE_URL"
}

# Main deployment function
main() {
    echo "========================================"
    echo "           EVENTAPP DEPLOYMENT"
    echo "========================================"
    echo ""
    
    # Check dependencies
    check_dependencies
    
    # Build frontend
    build_frontend
    
    # Deploy frontend
    deploy_frontend
    
    # Deploy backend
    deploy_backend
    
    # Setup database
    setup_database
    
    echo ""
    echo "========================================"
    echo "           DEPLOYMENT COMPLETE"
    echo "========================================"
    echo ""
    print_success "Frontend: Deploy to Vercel manually"
    print_success "Backend: Deploy to Railway manually"
    print_success "Database: Set up Supabase manually"
    echo ""
    print_status "Next steps:"
    print_status "1. Complete Vercel deployment"
    print_status "2. Complete Railway deployment"
    print_status "3. Set up Supabase database"
    print_status "4. Connect all services"
    print_status "5. Test the application"
}

# Run main function
main "$@"
