# Healthcare Specialization Profile

> **Category:** Profile / Industry-Specific
> **Usage:** Applied when project involves health data or medical systems

---

## Activation Trigger
```
ACTIVATE WHEN:
→ Project handles patient data (PHI — Protected Health Information)
→ Project integrates with medical systems (EHR, lab, pharmacy)
→ HIPAA or LGPD health data requirements apply
→ User mentions: healthcare, saúde, hospital, clínica, paciente, prontuário
```

## HIPAA / LGPD Health Data Compliance

### PHI (Protected Health Information) — What Counts
```
ANY data that can identify a patient + relates to health:
→ Names, dates (birth, admission, discharge)
→ Phone, email, address, SSN/CPF
→ Medical record numbers
→ Health plan numbers
→ Diagnoses, procedures, medications
→ Lab results, imaging
→ Biometric data
→ Photos, device IDs
```

### Technical Safeguards
- [ ] **Encryption at rest** — AES-256 for ALL PHI fields
- [ ] **Encryption in transit** — TLS 1.3 mandatory
- [ ] **Access control** — Role-based with minimum necessary access
- [ ] **Audit logging** — Log EVERY access to PHI (who, what, when)
- [ ] **Automatic logout** — Session timeout after 10 minutes inactivity
- [ ] **Unique user IDs** — No shared accounts
- [ ] **Emergency access** — Break-the-glass procedure for emergencies
- [ ] **Data backup** — Encrypted backups with tested recovery
- [ ] **Integrity controls** — Checksums/hashes to detect data tampering
- [ ] **Transmission security** — End-to-end encryption for PHI transfers

### Data Handling Patterns
```typescript
// PHI fields must be explicitly marked and encrypted
interface PatientRecord {
  id: string;                          // System ID (not PHI)
  // PHI fields — encrypted at rest
  name: EncryptedField<string>;        // Patient name
  cpf: EncryptedField<string>;         // CPF number
  dateOfBirth: EncryptedField<Date>;
  diagnosis: EncryptedField<string[]>;
  medications: EncryptedField<Medication[]>;
  
  // Non-PHI fields
  createdAt: Date;
  updatedAt: Date;
  createdBy: string;                   // Provider ID
}

// Access logging — mandatory for ALL PHI access
async function getPatientRecord(patientId: string, requestedBy: string): Promise<PatientRecord> {
  // 1. Verify authorization
  await verifyAccess(requestedBy, patientId, 'read');
  
  // 2. Fetch record
  const record = await db.patient.findUnique({ where: { id: patientId } });
  
  // 3. Log access (MANDATORY — HIPAA requirement)
  await auditLog.create({
    action: 'PHI_ACCESS',
    resource: 'patient_record',
    resourceId: patientId,
    accessedBy: requestedBy,
    timestamp: new Date(),
    purpose: 'treatment',  // Must document purpose
  });
  
  // 4. Decrypt and return
  return decryptPatientRecord(record);
}
```

## Interoperability Standards

| Standard | Use | Format |
|---|---|---|
| **HL7 FHIR** | Modern healthcare data exchange | JSON/XML REST API |
| **HL7 v2** | Legacy hospital systems | Pipe-delimited messages |
| **DICOM** | Medical imaging | Binary format |
| **ICD-10** | Diagnosis codes | Code system |
| **LOINC** | Lab results | Code system |
| **SNOMED CT** | Clinical terminology | Ontology |

## Consent Management
```
PATIENT CONSENT REQUIREMENTS:
→ Explicit consent before collecting PHI
→ Purpose-specific consent (treatment, research, marketing are SEPARATE)
→ Right to revoke consent at any time
→ Consent audit trail (when consented, what was consented to)
→ Minimum necessary principle (only collect what's needed for stated purpose)
→ Data retention policy with auto-deletion after purpose is fulfilled
```
