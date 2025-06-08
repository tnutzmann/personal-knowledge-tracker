package de.tnutzmann.personal_knowledge_tracker.backend.model;

import java.io.Serializable;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name="users")
public class User implements Serializable { 
  
  @Id
  @GeneratedValue
  private UUID id;

  @Column(name="keycloak_id", nullable=false, unique=true)
  private String keycloakId;
}