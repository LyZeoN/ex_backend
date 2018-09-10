import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Routes, RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { MatInputModule } from '@angular/material';

import { PlayerComponent } from './player.component';
import { SubtitleComponent } from './subtitle.component'
import { TimecodeComponent } from './timecode.component'
import { TimecodeDialogComponent } from './dialog/timecode_dialog.component'

import {
  MatButtonModule,
  MatIconModule,
  MatProgressSpinnerModule,
  MatSelectModule,
  MatSliderModule
  } from '@angular/material'

import {PipesModule} from '../pipes/pipes.module'

import * as dashjs from 'dashjs'

export const ROUTES: Routes = [
  { path: '', component: PlayerComponent }
];

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    MatButtonModule,
    MatIconModule,
    MatInputModule,
    MatProgressSpinnerModule,
    MatSelectModule,
    MatSliderModule,
    PipesModule,
    RouterModule.forChild(ROUTES)
  ],
  declarations: [
    PlayerComponent,
    SubtitleComponent,
    TimecodeComponent,
    TimecodeDialogComponent
  ],
  entryComponents: [
    SubtitleComponent,
    TimecodeComponent,
    TimecodeDialogComponent,
  ]
})

export class PlayerModule { }
