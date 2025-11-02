# Portfolio Assistant Bot - Architecture Decision Record

## Context and Requirements

The Portfolio Assistant Bot is a prototype application designed to help users manage their investment portfolios through a Telegram interface.

### Key Requirements

- Simple user interaction via Telegram
- Secure storage of portfolio data
- ACID compliance for financial transactions
- Low maintenance overhead
- Cost-effective deployment

## Architecture Decisions

### 1. Application Architecture

- **Pattern**: Single process application
- **Rationale**: 
  - Simplified deployment and maintenance
  - Sufficient for prototype usage
  - Easy debugging and monitoring

### 2. Technology Stack

- **Programming Language**: Python 3.11+
  - Strong async support
  - Rich ecosystem for financial applications
  - Excellent Telegram bot libraries

- **Key Libraries**:
  
  ```text
  python-telegram-bot==20.6
  SQLAlchemy==2.0.23
  requests==2.31.0
  pydantic==2.4.2
  ```

### 3. Database

- **Choice**: SQLite
- **Rationale**:
  - ACID compliance
  - Zero configuration
  - Single file storage
  - Easy backup
  - Sufficient for expected load

### 4. Deployment Model

- **Platform**: DigitalOcean VPS (Ubuntu 22.04 LTS)
- **Specifications**:
  - 1GB RAM
  - 1 vCPU
  - 25GB SSD
- **Cost**: $5/month

### 5. Service Management

- **Method**: Systemd service
- **Benefits**:
  - Automatic restart
  - System boot startup
  - Log management
  - Health monitoring

## Project Structure
```
/opt/portfolio-bot/
├── src/
│   ├── models/
│   │   └── database.py
│   ├── services/
│   │   └── portfolio_service.py
│   ├── bot/
│   │   └── telegram_bot.py
│   └── main.py
├── tests/
├── requirements.txt
├── backup.sh
└── health_check.py
```

## Monitoring and Maintenance

### Backup Strategy
- Daily SQLite database backup
- 7-day retention period
- Automated via cron job

### Health Monitoring
- 5-minute interval checks
- Telegram API connectivity verification
- Log file monitoring

## Security Considerations

### Data Protection
- SQLite file permissions
- Environment variables for secrets
- Regular system updates
- Firewall configuration

### Backup Security
- Encrypted backups
- Secure backup location
- Regular backup testing

## Future Considerations

### Potential Scalability Paths
1. Migration to PostgreSQL if needed
2. Implementation of caching layer
3. Separation into microservices
4. Container-based deployment

### Monitoring Enhancements
1. Integration with monitoring services
2. Advanced metrics collection
3. Automated alerting system

## Documentation and Support
- System architecture documentation
- Deployment procedures
- Backup and recovery procedures
- Monitoring and alerting setup
- Incident response procedures

---

*Last Updated: November 1, 2025*  
*Author: Mike (Technical Lead)*